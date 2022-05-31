### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 63e4bfd0-d176-11ec-1b20-1b8ece55ecf7
using PorousMaterials, PyPlot, Printf

# ╔═╡ 4a070376-901b-458b-ab0b-ea1bb992098a
md"""
# Calculate Diffusion Coefficient


The Free Energy Profile $F(q)$ , for an adsorbate hopping along the reaction coordinate, $q$, can be calculated by the mean energy of insertion of the (spherical) adsorbate molecule using the FF parameters in the planes orthogonal to the reaction coordinate:

$$F(q) = -k_B T ln\langle e^{-\beta \Delta U} \rangle_q$$

here, the angled brackets indicate that we are taking the Boltzmann factor averaged over all allowable insertions of $q$. In practice, we do this using Monte-Carlo integration, and only accept contributions that fall below a given energy cuttoff. 

The cavity-to-cavity hopping rate is given by:

$$k_{C_1 \rightarrow C_2} = \kappa \sqrt{\frac{k_B T}{2 \pi m}} \frac{e^{-\beta F(q^*)}}{\int_{cage} e^{-\beta F(q)} \,dq}$$

where $m$ is the mass of the adsorbe, $q$ is the reaction coordinate, $F$ is the average free energy per particle as a function of the reaction coordinate, $T$ is the temerature (T = 298 K), and $\kappa$ is the Bennett-Chandler dynamic correction. \kappa = 1 is a good approximatin for infinite dilution.
The space is partitioned such that the dividing surface is perpendicular to the reaction cordinate and passes through the location of the maximum free energy barrier along the path, $F(q^*)$.

To get the self-diffusion coefficient:
$$D_s = \frac{\kappa}{2d} \lambda^2 k_{C_1 \rightarrow C_2}$$

where $\lambda$ is the cavity-to-cavity
"""

# ╔═╡ c15febf5-afe0-4e31-96ab-a98d530fb33d
md"
## TODO:
1. run sim for both materials and all adsorbates
2. make a scatter that plots the energy minimum
"

# ╔═╡ f9a6c7f7-5aeb-4051-93be-11c2b28eecb2
function compute_seg_grid(xtal::Crystal, adsorbate::Molecule, ljff::LJForceField;
						  resolution::Float64=0.1,     # units: Å
						  energy_cutoff::Float64=50.0  # units: kJ/mol
)
	grid = energy_grid(xtal, adsorbate, ljff, resolution=resolution)
	
	segmented_grid = PorousMaterials._segment_grid(grid, energy_cutoff, true)
	
	connections = PorousMaterials._build_list_of_connections(segmented_grid)
	return segmented_grid, connections
end

# ╔═╡ bb290539-17b0-4b1f-acf6-5334af142111
function get_channel(connections::Vector{PorousMaterials.SegmentConnection};
					 connection_id::Int=2)
	for con in connections
		if con.src == con.dst && con.src == connection_id
			q_axis = con.direction
			id_q_axis = findfirst(q_axis .== 1)
			return q_axis, id_q_axis
		else
			continue
		end
	end
	return
end

# ╔═╡ b77fa782-5a58-43e0-9854-e5feffcdbc97
# function to check if adsorbate is in the channel
function in_my_channel(xf::Vector{Float64}, segmented_grid::Grid)  
	xf_id = xf_to_id(segmented_grid.n_pts, xf)
	return segmented_grid.data[xf_id...] == 1
end

# ╔═╡ f95896c0-ef5f-43b3-b537-1566124f042b
function free_energy_on_plane(q::Float64, _xtal::Crystal, _adsorbate::Molecule, 
	                          ljff::LJForceField, id_q_axis::Int, 
	                          segmented_grid::Grid{Int64}, 
	                          rep_factors::Tuple{Int, Int, Int}; 
                              nb_total_insertions::Union{Float64, Int64}=1e6,
							  Temp::Float64=298.0, 
							  R_btz::Float64=0.00831446261815324)	
    avg_boltzmann = 0.0 # will be the free energy
	nb_total_insertions = Int(nb_total_insertions) # make sure it's an Int 


	# replicate to make sure
	xtal = replicate(_xtal, rep_factors)
    adsorbate = deepcopy(_adsorbate)
	adsorbate = Frac(adsorbate, xtal.box) # adsorbate lies in replicated xtal

	nb_insertions = 0
    while nb_insertions < nb_total_insertions
		# a coord in _xtal.box (to see if we are in the correct channel)
        xf = rand(3)
		xf[id_q_axis] = q

		if ! in_my_channel(xf, segmented_grid)
			continue
		end

		# if we get to here, we found the channel.
        nb_insertions += 1

		# a coord in xtal.box (for energy calcs)
		xf ./= rep_factors

	    translate_to!(adsorbate, Frac(xf))
            
		energy = vdw_energy(xtal, adsorbate, ljff) # units: K
            
        avg_boltzmann += exp(-energy / Temp)
    end # MC integration
	avg_boltzmann /= nb_insertions

	return - R_btz * Temp * log(avg_boltzmann) # kJ/mol
end

# ╔═╡ 626b24f7-8c9c-48c9-bb2b-0d4fbefafbb6
begin 
	# thermo and energy calc params
	R = 8.31446261815324 / 1000 # Ideal Gas Constant, units: kJ/(mol-K)
	T = 298.0                   # units: K
	β = 1 / (R * T)             # units: (kJ/mol)⁻¹
	ljff = LJForceField("UFF")

	# structures
	crystal_structures = Crystal.(["NiPyC2_experiment.cif", "Pn_Ni-PyC-NH2.cif"])
	xtal_keys = [:nipyc, :nipycnh] # convenient for results Dict

	# MC integration params
	ln = 125
	nb_ins = 1e6
	qs = range(0.0, 1.0, length=ln)

	# results dictionary
	results = Dict{Tuple{Symbol, Symbol}, Any}()
	
	# outter loop - adsorbates
	for adsorbate in Molecule.(["Xe", "Kr"])
		# molecular weight
		if adsorbate.species == :Xe
			mw_adsorbate = 131.293 / 1000 # kg/mol
		elseif adsorbate.species == :Kr
			mw_adsorbate = 83.798 / 1000
		end
		
		# inner loop - crystals
		for (i, xtal) in enumerate(crystal_structures)
			xtal_key = xtal_keys[i]
			# key for results Dict
			results[(xtal_key, adsorbate.species)] = Dict{Symbol, Any}()

			# get rep factors
			rep_factors = replication_factors(xtal, ljff)
			write_xyz(xtal)
			write_vtk(xtal.box, "unit_cell")
			
			###
			#  Get Grids
			###
			segmented_grid, connections = compute_seg_grid(xtal, adsorbate, ljff,
				resolution=0.1)
			
			q_axis, id_q_axis = get_channel(connections)
			
			# store qs, q_axis, and id_q_axis in results
			push!(results[(xtal_key, adsorbate.species)], :qs => qs)
			push!(results[(xtal_key, adsorbate.species)], :q_axis => q_axis)
			push!(results[(xtal_key, adsorbate.species)], :id_q_axis => id_q_axis)

			###
			#  Get Free Energy Profile
			###
			Fs = [free_energy_on_plane(q, xtal, adsorbate, ljff, id_q_axis, segmented_grid, rep_factors, nb_total_insertions=nb_ins) for q in qs]

			# store the result
			push!(results[(xtal_key, adsorbate.species)], :free_energy => Fs)
		
			###
			#  Calculate Diffusion Coefficient
			###
			F★ = maximum(Fs) # kJ/mol
			energy_barrier = maximum(Fs) - minimum(Fs) # kJ/mol
			λ = xtal.box.f_to_c[id_q_axis, id_q_axis] # length of hop
			Δq = λ / (length(qs) - 1) # Å
			
			# dynamic update, correction, factor, is 1 at infinite dilution
			κ = 1.0 # units: unitless
		
			# average velocity given by Boltzman dist.
			#    mw_adsorbate [=] kg / mol
			#    RT [=] kJ/mol, i.e. 1000RT [=] J / mol
			#    [J] = [force * distance] = [N - m ] = [kg * m / s² - m] = [kg * m² / s²]
			#    (1000 RT) / (2 π mw_adsorbate) [=] m² / s²
			#    10 is for: 1 m/s = 10 Å/ns
			#       1 m / 10^[10] Å
			#       1 s / 10^9 ns
			avg_velocity = 10 * sqrt((1000 * R * T) / (2 * π * mw_adsorbate)) # units: Å / ns 
		
			integral_botlzmann = sum(exp.(-β * Fs[1:end-1])) * Δq # mid-point rule
		
			hop_rate = κ * avg_velocity * exp(-β * F★) / integral_botlzmann # 1 / ns
		
			diff_coeff = (κ / 6) * λ^2 * hop_rate # units: [Å²/ns]
			diff_coeff = diff_coeff * (1e-8)^2 / 1e-9 # units [cm²/s]
			# store the result
			push!(results[(xtal_key, adsorbate.species)], 
				  :self_diffusion => diff_coeff)
		end
	end
end

# ╔═╡ 12699c8b-4623-458e-8c6f-911d970fd6d1
begin
	###
	#  add Henry Coefficients to the results dictionary for ease of use
	###
	push!(results[(:nipyc, :Xe)], :Henry => 53.78) # mmol/(g-bar)
	push!(results[(:nipyc, :Kr)], :Henry =>  3.14) # mmol/(g-bar)
	
	push!(results[(:nipycnh, :Xe)], :Henry => 98.25) # mmol/(g-bar)
	push!(results[(:nipycnh, :Kr)], :Henry =>  4.85) # mmol/(g-bar)
	
	###
	#  Calculate Diffusive Selectivity
	#  S_dif = Dₛ₁ / Dₛ₂
	###
	nipyc_dif_sel   = results[(:nipyc, :Xe)][:self_diffusion] / results[(:nipyc, :Kr)][:self_diffusion]
	nipycnh_dif_sel = results[(:nipycnh, :Xe)][:self_diffusion] / results[(:nipycnh, :Kr)][:self_diffusion]
	
	###
	#  Calculate Membrane Selectivity
	#  S_mem = (Dₛ₁ H₁) / (Dₛ₂ H₂)
	###
	nipyc_mem_sel   = (results[(:nipyc, :Xe)][:self_diffusion] * results[(:nipyc, :Xe)][:Henry]) / 
	                    (results[(:nipyc, :Kr)][:self_diffusion] * results[(:nipyc, :Kr)][:Henry])
	
	nipycnh_mem_sel = (results[(:nipycnh, :Xe)][:self_diffusion] * results[(:nipycnh, :Xe)][:Henry]) / 
	                    (results[(:nipycnh, :Kr)][:self_diffusion] * results[(:nipycnh, :Kr)][:Henry])
	
	
	println("Xtal - NiPyC2_experiment")
	println("\tDiffusive Selectivity: S_{Xe/Kr} = $(nipyc_dif_sel)")
	println("\tMembrane Selectivity:  S_{Xe/Kr} = $(nipyc_mem_sel)\n")
	
	println("Xtal - Pn_Ni-PyC-NH2.cif")
	println("\tDiffusive Selectivity: S_{Xe/Kr} = $(nipycnh_dif_sel)")
	println("\tMembrane Selectivity:  S_{Xe/Kr} = $(nipycnh_mem_sel)")
end

# ╔═╡ 61d19b40-33fe-48a5-aff7-bb2d170f1a8f
results

# ╔═╡ d55f3e0b-caab-4ef5-b7bf-24d9827f24d9
begin 
	mof_2_prettymof = Dict("Pn_Ni-PyC-NH2.cif" => L"Ni(PyC-NH$_2$)$_2$",
							"NiPyC2_experiment.cif" => L"Ni(PyC)$_2$")
	
	for (i, xtal) in enumerate(crystal_structures)
		for adsorbate in Molecule.(["Xe", "Kr"])
			# extract results to simplify plotting 
			id_q_axis = results[(xtal_keys[i], adsorbate.species)][:id_q_axis]
			free_energies = results[(xtal_keys[i], adsorbate.species)][:free_energy] 
			sampled_qs = results[(xtal_keys[i], adsorbate.species)][:qs]
			diffusion_coeff = results[(xtal_keys[i], adsorbate.species)][:self_diffusion]
			
			figure()
			xlabel("reaction coordinate, q [Å]")
			ylabel("free energy of $(String(adsorbate.species)) [kJ/mol]")
			plot(sampled_qs * xtal.box.f_to_c[id_q_axis, id_q_axis], 
				free_energies, marker="o", 
				label="", color=adsorbate.species == :Xe ? "g" : "r")
			# title(mof_2_prettymof[xtal.name])
			legend(title=@sprintf("Dₛ, %s = %.3e cm²/s", String(adsorbate.species), diffusion_coeff))
			tight_layout()
			savefig("diff_coeff_$(String(adsorbate.species))_$(xtal.name).pdf", format="pdf")
			gcf()
		end
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PorousMaterials = "68953c7c-a3c7-538e-83d3-73516288599e"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"

[compat]
PorousMaterials = "~0.4.0"
PyPlot = "~2.10.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Aqua]]
deps = ["Compat", "Pkg", "Test"]
git-tree-sha1 = "ad36b54d55c1f8494baae1cea53f08fa387a7b58"
uuid = "4c88cf16-eb10-579e-8560-4a9242c79595"
version = "0.5.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "81f0cb60dc994ca17f68d9fb7c942a5ae70d9ee4"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.8"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AtomsBase]]
deps = ["PeriodicTable", "StaticArrays", "Unitful", "UnitfulAtomic"]
git-tree-sha1 = "3b43e616755e3ea2bb06f3ba4b34ac456441b154"
uuid = "a963bdd2-2df7-4f54-a1ee-49d51e6be12a"
version = "0.2.2"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BinaryProvider]]
deps = ["Libdl", "Logging", "SHA"]
git-tree-sha1 = "ecdec412a9abc8db54c0efc5548c64dfce072058"
uuid = "b99e7846-7c00-51b0-8f62-c81ae34c0232"
version = "0.5.10"

[[Bio3DView]]
deps = ["Requires"]
git-tree-sha1 = "7f472efd9b6af772307dd017f9deeff2a243754f"
uuid = "99c8bb3a-9d13-5280-9740-b4880ed9c598"
version = "0.1.3"

[[CSV]]
deps = ["Dates", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode"]
git-tree-sha1 = "b83aa3f513be680454437a0eee21001607e5d983"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.8.5"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "a985dc37e357a3b22b260a5def99f3530fb415d3"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.2"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

[[ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "daa21eb85147f72e41f6352a57fccea377e310a9"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.4"

[[DataStructures]]
deps = ["InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "88d48e133e6d3dd68183309877eac74393daa7eb"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.17.20"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "28d605d9a0ac17118fe2c5e9ce0fbb76c3ceb120"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.0"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FIGlet]]
deps = ["BinaryProvider", "Pkg"]
git-tree-sha1 = "bfc6b52f75b4720581e3e49ae786da6764e65b6a"
uuid = "3064a664-84fe-4d92-92c7-ed492f3d8fae"
version = "0.2.1"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "9267e5f50b0e12fdfd5a2455534345c4cf2c7f7a"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.14.0"

[[FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "51c8f36c81badaa0e9ec405dcbabaf345ed18c84"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.11.1"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "89cc49bf5819f0a10a7a3c38885e7c7ee048de57"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.29"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "57c021de207e234108a6f1454003120a1bf350c4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.6.0"

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "336cc738f03e069ef2cac55a104eb823455dca75"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.4"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "Printf", "Reexport", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "81b9477b49402b47fbe7f7ae0b252077f53e4a08"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.22"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "f27132e551e959b3667d8c93eae90973225032dd"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.1.1"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "2af69ff3c024d13bde52b34a2a7d6887d4e7b438"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f8c673ccc215eb50fcadb285f522420e29e69e1c"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "0.4.5"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "50310f934e55e5ca3912fb941dec199b49ca9b68"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.2"

[[NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
git-tree-sha1 = "87d0a91efe29352d5caaa271ae3927083c096e33"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "0.11.4"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "7a28efc8e34d5df89fc87343318b0a8add2c4021"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "bfd7d8c7fd87f04543810d9cbd3995972236ba1b"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.2"

[[PeriodicTable]]
deps = ["Base64", "Test", "Unitful"]
git-tree-sha1 = "33a08817dc1a025afeb093d06a8a5cb6a5961e2c"
uuid = "7b2266bf-644c-5ea3-82d8-af4bbd25a884"
version = "1.1.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "1185511cac8ab9d0b658b663eae34fe9a95d4332"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "0.6.1"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[PorousMaterials]]
deps = ["Aqua", "CSV", "DataFrames", "Distributed", "FIGlet", "FileIO", "Graphs", "JLD2", "LinearAlgebra", "OffsetArrays", "Optim", "Polynomials", "Printf", "ProgressMeter", "Random", "Reexport", "Roots", "SpecialFunctions", "Statistics", "StatsBase", "Test", "Xtals"]
git-tree-sha1 = "739f791ca3c03c2bc519dd353d09cfb3a57fc581"
uuid = "68953c7c-a3c7-538e-83d3-73516288599e"
version = "0.4.0"

[[PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "1fc929f47d7c151c839c5fc1375929766fb8edcc"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.93.1"

[[PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "14c1b795b9d764e1784713941e787e1384268103"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.10.0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "b4ed4a7f988ea2340017916f7c9e5d7560b52cae"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "0.8.0"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[Roots]]
deps = ["Printf"]
git-tree-sha1 = "dcc013908465ca1019b34b4bf547b6a187d195f9"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "0.8.4"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "6a2f7d70512d205ca8c7ee31bfa9f142fe74310c"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.12"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures", "Random", "Test"]
git-tree-sha1 = "03f5898c9959f8115e30bc7226ada7d0df554ddd"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "0.3.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["OpenSpecFun_jll"]
git-tree-sha1 = "d8d8b8a9f4119829410ecd706da4cc8594a1e020"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "0.10.3"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "3a2a99b067090deb096edecec1dc291c5b4b31cb"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.5"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics"]
git-tree-sha1 = "19bfcb46245f69ff4013b3df3b977a289852c3a1"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.32.2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "b649200e887a487468b71821e2644382699f1b0f"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.11.0"

[[UnitfulAtomic]]
deps = ["Unitful"]
git-tree-sha1 = "903be579194534af1c4b4778d1ace676ca042238"
uuid = "a7773ee8-282e-5fa2-be4e-bd808c38a91a"
version = "1.0.0"

[[VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[Xtals]]
deps = ["Aqua", "AtomsBase", "Bio3DView", "CSV", "DataFrames", "FIGlet", "Graphs", "JLD2", "LinearAlgebra", "Logging", "MetaGraphs", "Printf", "StaticArrays", "UUIDs", "Unitful"]
git-tree-sha1 = "c877d5c243ba6ff8deeda63482ca7ad716ca5041"
uuid = "ede5f01d-793e-4c47-9885-c447d1f18d6d"
version = "0.3.12"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─4a070376-901b-458b-ab0b-ea1bb992098a
# ╟─c15febf5-afe0-4e31-96ab-a98d530fb33d
# ╠═63e4bfd0-d176-11ec-1b20-1b8ece55ecf7
# ╠═626b24f7-8c9c-48c9-bb2b-0d4fbefafbb6
# ╠═f9a6c7f7-5aeb-4051-93be-11c2b28eecb2
# ╠═bb290539-17b0-4b1f-acf6-5334af142111
# ╠═b77fa782-5a58-43e0-9854-e5feffcdbc97
# ╠═f95896c0-ef5f-43b3-b537-1566124f042b
# ╠═12699c8b-4623-458e-8c6f-911d970fd6d1
# ╠═61d19b40-33fe-48a5-aff7-bb2d170f1a8f
# ╠═d55f3e0b-caab-4ef5-b7bf-24d9827f24d9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002

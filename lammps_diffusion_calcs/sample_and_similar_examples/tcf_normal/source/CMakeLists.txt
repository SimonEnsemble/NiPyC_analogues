#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -O3 -lm" )
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -O3" )

set( tcf_src   
     main.c
     corrdata.c
     readinput.c
     readtraj.c
     sample.c
     utils.c
   )

#add_library(math STATIC IMPORTED)

#find_library(M_LIB m)
add_executable(tcf ${tcf_src})
target_link_libraries(tcf m)

install (TARGETS tcf DESTINATION bin)


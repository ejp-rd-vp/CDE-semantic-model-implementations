import sys
from embuilder.builder import EMB

a =__import__(sys.argv[1])

if sys.argv[2] == "obda":
    builder = EMB(a.config, a.prefixes, a.triplets)
    test = builder.transform_OBDA()
    print(test)

elif sys.argv[2] == "yarrrml":
    builder = EMB(a.config, a.prefixes, a.triplets)
    test = builder.transform_YARRRML()
    print(test)

elif sys.argv[2] == "shex":
    builder = EMB(a.config, a.prefixes, a.triplets)
    test = builder.transform_ShEx("this")
    print(test)
else:
    sys.exit("Argument used for defining the method is not correct, please add 'obda' 'shex' or 'yarrrml' as second parameter to define the method")
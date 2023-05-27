#Requires AutoHotkey v2.0
#Warn All

#Include <DataType>
#Include <Test>

Test( "DataType",
    ( expect ) => expect( DataType.bool, "bool" ).ToBe( 1 ),
    ( expect ) => expect( DataType.char, "char" ).ToBe( 1 ),
    ( expect ) => expect( DataType.int, "int" ).ToBe( 4 ),
    ( expect ) => expect( DataType.float, "float" ).ToBe( 4 ),
    ( expect ) => expect( DataType.double, "double" ).ToBe( 8 ),
)

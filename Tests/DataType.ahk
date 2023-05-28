#Requires AutoHotkey v2.0
#Warn All

#Include <DataType>
#Include <Test>

STRUCT := {
    data0: "30 char",
    data1: "unsigned_long",
    data2: "long double",
    data3: "signed short",
}

DataStruct := DataType( STRUCT )

Test( "DataType",
    ( expect ) => expect( DataType.bool, "bool" ).ToBe( 1 ),
    ( expect ) => expect( DataType.char, "char" ).ToBe( 1 ),
    ( expect ) => expect( DataType.int, "int" ).ToBe( 4 ),
    ( expect ) => expect( DataType.float, "float" ).ToBe( 4 ),
    ( expect ) => expect( DataType.double, "double" ).ToBe( 8 ),
    ( expect ) => expect( STRUCT ).ToBeDefined(),
    ( expect ) => expect( DataType.unsigned_long, "unsigned long" ).ToBe( 4 ),
    ( expect ) => expect( DataType.long_double, "long double" ).ToBe( 8 ),
    ( expect ) => expect( DataType.signed_short, "signed_short" ).ToBe( 2 ),
    ( expect ) => expect( DataStruct.Size(), "STRUCT total size" ).ToBe( 44 ),
    ( expect ) => expect( DataStruct.Size( "unknown" ), "STRUCT[unknown] size" ).ToBe( 0 ),
    ( expect ) => expect( DataStruct.Size( "data0" ), "STRUCT[data0] size" ).ToBe( 30 ),
    ( expect ) => expect( DataStruct.Size( "data1" ), "STRUCT[data1] size" ).ToBe( 4 ),
    ( expect ) => expect( DataStruct.Size( "data2" ), "STRUCT[data2] size" ).ToBe( 8 ),
    ( expect ) => expect( DataStruct.Size( "data3" ), "STRUCT[data3] size" ).ToBe( 2 ),
    ( expect ) => expect( DataStruct.Offset( "unknown" ), "STRUCT[unknown] offset" ).ToBe( -1 ),
    ( expect ) => expect( DataStruct.Offset( "data1" ), "STRUCT[data1] offset" ).ToBe( 30 ),
    ( expect ) => expect( DataStruct.Offset( "data2" ), "STRUCT[data2] offset" ).ToBe( 34 ),
    ( expect ) => expect( DataStruct.Offset( "data3" ), "STRUCT[data3] offset" ).ToBe( 42 ),
    ( expect ) => expect( DataStruct.Address(), "STRUCT base address" ).ToBe( DataStruct.Buffer.Ptr ),
    ( expect ) => expect( DataStruct.Address( "unknown" ), "STRUCT[unknown] address" ).ToBe( 0 ),
    ( expect ) => expect( DataStruct.Address( "data0" ), "STRUCT[data0] address" ).ToBe( DataStruct.Buffer.Ptr + DataStruct.Size( "data0" ) ),
    ( expect ) => expect( DataStruct.Address( "data1" ), "STRUCT[data1] address" ).ToBe( DataStruct.Buffer.Ptr + DataStruct.Size( "data0" ) + DataStruct.Size( "data1" ) ),
    ( expect ) => expect( DataStruct.Address( "data2" ), "STRUCT[data2] address" ).ToBe( DataStruct.Buffer.Ptr + DataStruct.Size( "data0" ) + DataStruct.Size( "data1" ) + DataStruct.Size( "data2" ) ),
    ( expect ) => expect( DataStruct.Address( "data3" ), "STRUCT[data3] address" ).ToBe( DataStruct.Buffer.Ptr + DataStruct.Size( "data0" ) + DataStruct.Size( "data1" ) + DataStruct.Size( "data2" ) + DataStruct.Size( "data3" ) ),
)

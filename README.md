# EnumGen
EnumGen is a library and CLI tool that makes it easy to create enums from strings.

# Usage
## Library
Example
```Swift
let generator = try EnumGen(strings: , enumName: <Enum type name>, enumType: <Types that Enum inherits from>)
try generator.generate()
```
### Arguments
|  Argument |  Type  |  Discription  |
| ---- | ---- | ---- |
|  strings  |  String  |  Array of String types to be converted to enum  |
|  enumName  |  String  |  Enum type name  |
|  enumType  |  Any.Type? |  Types that enum inherits  |

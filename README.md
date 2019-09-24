=3D Object Definitions Parser Analyser

The purpose of the project was to parse information from a text using flex. In this case, data about 3D objects were parsed.

Objects are defined by tips, coordinates of texture and normal. In some cases the last two elements may be missing. Also,
objects can be defined with the help of component objects. These met the same definition criteria as for objects.

To achieve the identification of all the components we used 3 structures: Face, Component and Object. Thus, I could keep it easier
an record for the information of an object, its components and the girls object / components. To keep all the objects I used a vector
of that type and a global index that holds the current element in vector for which information is lost.

To identify the name of an object, we searched for the 'o' character the beginning of a row, if no one is identified, will be
considered to describe a single object, without specifying its name.

To find all the tips, look for the strings that start with 'v' and the number of points in the structure of the respective object or a is kept component. For the texture coordinates, look for 'vt', and for normal 'vn'.

To detect the components, we searched for the character 'g' at the beginning line in the text, and everything that meets the respective character, up when meeting another object or component, it is considered to be part of this.

For detecting girls, I searched separately for possible cases for their definition, namely: when a girl is defined only by tips, and tips
textured coordinates, peaks and normal or all three elements.

After the entire text has been parsed, the display is made, according to the data obtained.

Tazlauanu Bianca, 334CC
%{
#include <stdio.h>
#include <string.h>

int number_objects = 0;
int current_object = -1;

typedef struct {
	int number_faces;		// Total number of faces
	int number_faces_textured;	// Total number of faces with textures
	int number_faces_normals;	// Total number of faces with normals
} Face;

typedef struct {
	char name[50];			// Component name
	Face faces;			// Component faces
} Component;

typedef struct {
	char name[50];			// Object name
	int current_component;		// Object number of components
	int number_vertices;		// Object number of vertices
	int number_normals;		// Object number of faces with normals
	int number_textures;		// Object number of faces with textures
	Component components[100];	// Object components
	Face faces;			// Object faces
} Object;

Object objects[100] = {0};

%}

DIGIT	[a-zA-Z][a-zA-Z0-9_]*
FLOAT [+-]?([0-9]*[.])?[0-9]+

%%

^o" "*{DIGIT} {
		/* Object detected */
		current_object++;
		number_objects++;

		char *token;
   		token = strtok(yytext, " ");
   		token = strtok(NULL, " ");

		strcpy(objects[current_object].name, token);
	}

^v" "* {
		/* Vertex detected */
		if (current_object == -1) { 
			current_object = 0;
		}

		objects[current_object].number_vertices++;
	}

^vt" "* {
		/* Textured coordinate detected */
		objects[current_object].number_textures++;
	}

^vn" "* {
		/* Normal coordinate detected */
		objects[current_object].number_normals++;
	}

^g" "*{DIGIT} {
		/* Component detected */
		objects[current_object].current_component++;
	
		int component = objects[current_object].current_component;
        	char *token;
        	token = strtok(yytext, " ");
        	token = strtok(NULL, " ");

        	strcpy(objects[current_object].components[component].name, token);
        }

^f" "*{FLOAT}" "*{FLOAT}" "*{FLOAT} {
		/* Face detected: defined with vertices only */
		Object *object = &objects[current_object];
		
		if (object->current_component == -1) {
			object->faces.number_faces++;
		} else {
			Component *component = &object->components[object->current_component];
			component->faces.number_faces++;
		}
}

^f" "*[0-9]*\/\/[0-9]*" "*[0-9]*\/\/[0-9]*" "*[0-9]*\/\/[0-9]* {
		/* Face detected: defined with vertices and normal components */
		Object *object = &objects[current_object];

		if (object->current_component == -1) {
                        object->faces.number_faces++;
                        object->faces.number_faces_normals++;
                } else {
			Component *component = &object->components[object->current_component];
                        component->faces.number_faces++;
                        component->faces.number_faces_normals++;
                }
}

^f" "*[0-9]*\/[0-9]*" "*[0-9]*\/[0-9]*" "*[0-9]*\/[0-9]* {
		/* Face detected: defined with vertices and textured coordinates */
		Object *object = &objects[current_object];
  		
		if (object->current_component == -1) {
                        object->faces.number_faces++;
                        object->faces.number_faces_textured++;
                } else {
			Component *component = &object->components[object->current_component];
                        component->faces.number_faces++;
                        component->faces.number_faces_textured++;
                }
}

^f" "*[0-9]*\/[0-9]*\/[0-9]*" "*[0-9]*\/[0-9]*\/[0-9]*" "*[0-9]*\/[0-9]*\/[0-9]* {
		/* Face detected: defined with vertices, normal components and textured coordinates */
		Object *object = &objects[current_object];
		
		if (object->current_component == -1) {
                        objects->faces.number_faces++;
                        objects->faces.number_faces_normals++;
                        objects->faces.number_faces_textured++;
                } else {
			Component *component = &object->components[object->current_component];
			component->faces.number_faces++;
			component->faces.number_faces_normals++;
			component->faces.number_faces_textured++;
		}
}

.|\n    {   /* Ignore all other characters. */   }

%%

int yywrap(){}

/* Function that prints the number of faces defined with normals. */
void print_faces_with_normals(Face faces, char separator) {
	if (faces.number_faces_normals == 0) {
		printf("\n");

	} else if (faces.number_faces_normals == 1) {
		printf("%c 1 fata definita cu normale\n", separator);

	} else {
		printf("%c %d fete definite cu normale\n", separator, faces.number_faces_normals);
	}
}

/* Function that prints information about the faces of an object or component. */
void print_faces_stats(Face faces) {
	if (faces.number_faces > 0) {
		if (faces.number_faces == 1) {
			printf("1 fata");
		
		} else {
			printf("%d fete", faces.number_faces);
		}

		if (faces.number_faces_textured == 0) {
			print_faces_with_normals(faces, ':');

		} else if (faces.number_faces_textured == 1) {
			printf(": 1 fata definita cu coordonate de texturare");
			print_faces_with_normals(faces, ',');
		
		} else  {
			printf(": %d fete definite cu coordonate de texturare", faces.number_faces_textured);
			print_faces_with_normals(faces, ',');
		}
	}
}

/* Function that prints information about the components of an object. */
void print_components(Object object) {
	switch(object.current_component) {

		case -1:
			printf("Nu exista obiecte componente\n");
			break;

		case 0:
			printf("1 obiect component: %s\n", object.components[0].name);
			break;
	
		default:
			printf("%d obiecte componente:", object.current_component + 1);
				
			for (int i = 0; i < object.current_component; i++) {
				printf(" %s,", object.components[i].name);	
			}
		
			printf(" %s\n", object.components[object.current_component].name);
			break;
	}
}

/* Function that prints the number of vertices of an object. */
void print_vertices(Object object) {
	if (object.number_vertices == 1) {
		printf("1 varf\n");

	} else {
		printf("%d varfuri\n", object.number_vertices);
	}
}

/* Function that prints the number of faces with textured coordinates. */
void print_textured_coordinates(Object object) {
	if (object.number_textures == 1) {
		printf("1 coordonata de texturare\n");
		
	} else if (object.number_textures != 0) {
		printf("%d coordonate de texturare\n", object.number_textures);
	}
}

/* Function that prints the number of faces with normals. */
void print_normals(Object object) {
	if (object.number_normals == 1) {
		printf("1 normala\n");
		
	} else if (object.number_normals != 0) {
		printf("%d normale\n", object.number_normals);
	}
}

/* Function that prints information about the faces of a component. */
void print_component_faces(Object object) {
	switch(object.current_component) {
	
		case -1:
			print_faces_stats(object.faces);
			break;

		case 0:
			printf("%s", object.components[0].name);
			print_faces_stats(object.components[0].faces);
			break;

		default:
			for (int i = 0; i <= object.current_component; i++) {
				printf("%s: ", object.components[i].name);
				print_faces_stats(object.components[i].faces);
			}
			break;
	}
}

/* Function that prints all the information about an object. */
void print_object_stats(Object object) {
	print_components(object);
	print_vertices(object);
	print_textured_coordinates(object);
	print_component_faces(object);
}

int main(void)
{
	for (int i = 0; i < 100; i++) {
		objects[i].current_component = -1;
	}

	yylex();

	/* Print the information from the file depending on the number of objects detected. */
	switch(number_objects) {

		case 0:
			printf("1 obiect\n");
			print_object_stats(objects[0]);		
			break;

		case 1:
			printf("1 obiect: %s\n", objects[0].name);
			print_object_stats(objects[0]);
			break;

		default:
			printf("%d obiecte: ", number_objects);
			for (int i = 0; i < number_objects - 1; i++) {
				printf("%s, ", objects[i].name);
			}
			printf("%s\n", objects[number_objects - 1].name);

			for (int i = 0; i < number_objects; i++) {
				printf("%s\n", objects[i].name);
				print_object_stats(objects[i]);
			}
			break;
	}

	return 0;
}

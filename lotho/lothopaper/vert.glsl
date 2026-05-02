#version 330 core

in vec2 a_Position;
in vec2 a_TexCoord;

out vec2 v_TexCoord;

void main() {
    // Pass texture coordinates directly
    v_TexCoord = a_TexCoord;

    // Set the final position directly, no matrix math needed
    gl_Position = vec4(a_Position, 0.0, 1.0);
}
# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------

import copy
import hashlib

import numpy as np
import moderngl as mg
from array import array


class GLSLRenderer(object):
    def __init__(self):
        self._programs = {}
        self._vaos = {}

        self.gl_context = mg.create_standalone_context(require=330)
        self.src_texture = self.gl_context.texture((6000, 6000), 4, dtype="f4")
        self.src_texture2 = self.gl_context.texture((6000, 6000), 4, dtype="f4")
        self.dst_texture = self.gl_context.texture((6000, 6000), 4, dtype="f4")
        self.src_fbo = self.gl_context.framebuffer(self.src_texture)
        self.dst_fbo = self.gl_context.framebuffer(self.dst_texture)

        # Fullscreen quad in NDC
        self.vertices = self.gl_context.buffer(
            array(
                "f",
                [
                    # Triangle strip creating a fullscreen quad (x, y)
                    -1,  1,  # upper left
                    -1, -1,  # lower left
                    1, 1,    # upper right
                    1, -1,   # lower right
                ]
            )
        )

    def GetGLContext(self):
        return self.gl_context

    def Swap(self):
        """ Swap the textures. """
        self.src_texture, self.dst_texture = self.dst_texture, self.src_texture
        self.src_fbo, self.dst_fbo = self.dst_fbo, self.src_fbo

    def Write(self, image, texture):
        """ Do the writing to src_texture """
        image = image.GetImage()
        image = image.copy(order="C")
        viewport = (0, 0, *image.shape[1::-1])
        texture.write(image, viewport=viewport)
        return viewport

    def ReadNumpy(self):
        """ Returns a ``numpy.ndarray`` image. """
        raw = self.dst_fbo.read(components=4, dtype="f4", viewport=self.viewport)
        img = np.frombuffer(raw, dtype="float32").reshape((self.viewport[3], self.viewport[2], 4))
        image = img
        return image

    def WriteViewports(self, image, image2):
        if image2 is not None:
            self.viewport2 = self.Write(image2, self.src_texture2)
        self.viewport = self.Write(image, self.src_texture)

    def LoadGLSLFile(self, path):
        with open(path, 'r') as fp:
            glsl_shader = str(fp.read())
        return glsl_shader

    def Render(self, frag_shader, props, image, image2=None):
        hash_value = hashlib.md5(copy.copy(frag_shader).encode())
        vao = self._vaos.get(hash_value)
        self.WriteViewports(image, image2)

        if vao is None:
            vertex_shader = """
                #version 330
                
                in vec2 in_position;

                out vec2 tex_coord;

                void main() {
                    gl_Position = vec4(in_position, 0.0, 1.0);
                }
                """

            program = self.gl_context.program(vertex_shader=vertex_shader,
                                              fragment_shader=frag_shader)
            program["input_img"] = 0
            if image2 is not None:
                program["input_img2"] = 1

            vao = self.gl_context.vertex_array(program,
                                               [(self.vertices, "2f", "in_position")])

            self._programs[hash_value] = program
            self._vaos[hash_value] = vao

        # Pass values into the shader
        for prop in props:
            value = props[prop]
            if prop in program:
                program[prop] = value

        self.dst_fbo.use()
        self.dst_fbo.clear()
        self.dst_fbo.viewport = self.viewport
        self.src_texture.use(0)
        self.src_texture2.use(1)
        vao.render(mode=mg.TRIANGLE_STRIP)

    def Release(self):
        self.src_fbo.release()
        self.src_texture.release()
        self.src_texture2.release()
        for prog in self._programs.values():
            prog.release()
        for vao in self._vaos.values():
            vao.release()
        self.vertices.release()

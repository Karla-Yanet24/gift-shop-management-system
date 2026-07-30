package com.edu.pe.controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/imagenes/*")
public class ImagenServlet extends HttpServlet {

    private static final String BASE =
            "C:/FloreriaUploads";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String ruta = request.getPathInfo();

        if (ruta == null || ruta.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File archivo = new File(BASE + ruta);

        if (!archivo.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mime = getServletContext().getMimeType(archivo.getName());

        if (mime == null) {
            mime = "application/octet-stream";
        }

        response.setContentType(mime);
        response.setContentLengthLong(archivo.length());

        try (
                FileInputStream in = new FileInputStream(archivo);
                OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int leidos;

            while ((leidos = in.read(buffer)) != -1) {
                out.write(buffer, 0, leidos);
            }
        }
    }
}
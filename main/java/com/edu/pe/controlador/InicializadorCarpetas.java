package com.edu.pe.controlador;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.File;

/**
 * Se ejecuta automáticamente cuando la aplicación arranca en Tomcat.
 * Crea la carpeta externa de uploads (y sus subcarpetas) si no existen,
 * para que el sistema funcione en cualquier máquina sin pasos manuales.
 */
@WebListener
public class InicializadorCarpetas implements ServletContextListener {

    private static final String[] CARPETAS = {
        "C:/FloreriaUploads",
        "C:/FloreriaUploads/floreria",
        "C:/FloreriaUploads/comprobantes"
    };

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        for (String ruta : CARPETAS) {
            File carpeta = new File(ruta);
            if (!carpeta.exists()) {
                boolean creada = carpeta.mkdirs();
                System.out.println((creada ? "Carpeta creada: " : "No se pudo crear: ") + ruta);
            }
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // No se necesita limpieza al apagar el servidor
    }
}
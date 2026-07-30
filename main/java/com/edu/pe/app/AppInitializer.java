/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.edu.pe.app;

import com.edu.pe.modelo.dao.ProductoDAO;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;


@WebListener


public class AppInitializer implements ServletContextListener {
    private ProductoDAO prodDAO = new ProductoDAO();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        sce.getServletContext().setAttribute("productos", prodDAO.listarTodos());
        
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        
    }

    
    

}


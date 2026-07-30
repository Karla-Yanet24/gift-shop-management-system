/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.edu.pe.controlador;

import com.edu.pe.modelo.Categoria;
import com.edu.pe.modelo.dao.CategoriaDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Controlador del panel administrativo de categorías. CRUD completo.
 *
 * Acciones:
 *   - listar         (GET)  : lista todas las categorías -> listaCategorias -> PagAdminCategorias.jsp
 *   - nuevo           (GET)  : formulario vacío -> categoria -> FormCategoria.jsp
 *   - editar          (GET)  : formulario con datos -> categoria -> FormCategoria.jsp
 *   - guardar         (POST) : inserta o actualiza
 *   - activar         (GET)  : reactiva una categoría desactivada
 *   - desactivar      (GET)  : desactiva una categoría (no se borra físicamente)
 *
 * Protegido por FiltroAdmin (igual que AdminProductoControlador).
 */
@WebServlet(name = "AdminCategoriaControlador", urlPatterns = {"/AdminCategoriaControlador"})
public class AdminCategoriaControlador extends HttpServlet {

    private final CategoriaDAO categoriaDao = new CategoriaDAO();
    private final String pagListado = "PagAdminCategorias.jsp";
    private final String pagFormulario = "FormCategoria.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "nuevo":
                Nuevo(request, response);
                break;
            case "editar":
                Editar(request, response);
                break;
            case "guardar":
                Guardar(request, response);
                break;
            case "activar":
                CambiarEstado(request, response, true);
                break;
            case "desactivar":
                CambiarEstado(request, response, false);
                break;
            case "activarDedicatoria":
                ToggleDedicatoria(request, response, true);
                break;
            case "desactivarDedicatoria":
                ToggleDedicatoria(request, response, false);
                break;
            case "listar":
            default:
                Listar(request, response);
                break;
        }
    }

    protected void Listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Categoria> lista = categoriaDao.listarTodas();

        // Pre-calculamos cuántos productos tiene cada categoría, para no
        // invocar al DAO desde dentro del JSP (rompería la separación MVC).
        java.util.Map<Integer, Integer> conteoProductos = new java.util.HashMap<>();
        for (Categoria c : lista) {
            conteoProductos.put(c.getIdCategoria(), categoriaDao.contarProductos(c.getIdCategoria()));
        }

        request.setAttribute("listaCategorias", lista);
        request.setAttribute("conteoProductos", conteoProductos);
        request.getRequestDispatcher(pagListado).forward(request, response);
    }

    protected void Nuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categoria", new Categoria());
        request.getRequestDispatcher(pagFormulario).forward(request, response);
    }

    protected void Editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Categoria cat = categoriaDao.buscarPorId(id);

        if (cat == null) {
            request.getSession().setAttribute("error", "La categoría solicitada no existe.");
            response.sendRedirect("AdminCategoriaControlador?accion=listar");
            return;
        }

        request.setAttribute("categoria", cat);
        request.getRequestDispatcher(pagFormulario).forward(request, response);
    }

    protected void Guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        boolean permiteDedicatoria = request.getParameter("permiteDedicatoria") != null;

        if (nombre == null || nombre.trim().length() < 2) {
            request.getSession().setAttribute("error", "El nombre debe tener al menos 2 caracteres.");
            if (id > 0) {
                response.sendRedirect("AdminCategoriaControlador?accion=editar&id=" + id);
            } else {
                response.sendRedirect("AdminCategoriaControlador?accion=nuevo");
            }
            return;
        }

        Categoria c = new Categoria();
        c.setIdCategoria(id);
        c.setNombre(nombre);
        c.setDescripcion(descripcion);
        c.setPermiteDedicatoria(permiteDedicatoria);

        if (id == 0) {
            categoriaDao.insertar(c);
            request.getSession().setAttribute("mensaje", "Categoría creada correctamente.");
        } else {
            categoriaDao.actualizar(c);
            request.getSession().setAttribute("mensaje", "Categoría actualizada correctamente.");
        }

        response.sendRedirect("AdminCategoriaControlador?accion=listar");
    }
    
    protected void ToggleDedicatoria(HttpServletRequest request, HttpServletResponse response, boolean permite)
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        boolean ok = categoriaDao.toggleDedicatoria(id, permite);
        if (ok) {
            String texto = permite ? "activada" : "desactivada";
            request.getSession().setAttribute("mensaje", "Dedicatoria " + texto + " para la categoría.");
        } else {
            request.getSession().setAttribute("error", "No se pudo actualizar la dedicatoria.");
        }
        response.sendRedirect("AdminCategoriaControlador?accion=listar");
    }
    
    
    protected void CambiarEstado(HttpServletRequest request, HttpServletResponse response, boolean nuevoEstado)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean ok = categoriaDao.cambiarEstado(id, nuevoEstado);

        if (ok) {
            String texto = nuevoEstado ? "activada" : "desactivada";
            request.getSession().setAttribute("mensaje", "Categoría " + texto + " correctamente.");
        } else {
            request.getSession().setAttribute("error", "No se pudo cambiar el estado de la categoría.");
        }

        response.sendRedirect("AdminCategoriaControlador?accion=listar");
    }
    
    
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin controlador de categorías";
    }
}

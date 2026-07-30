
package com.edu.pe.controlador;

import com.edu.pe.modelo.Cliente;
import com.edu.pe.modelo.dao.AuthDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class AuthControlador extends HttpServlet {

    private final AuthDAO authDao = new AuthDAO();
    private final String pagLogin = "PagLogin.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String accion = request.getParameter("accion");

        if (accion != null && accion.equals("cerrar")) {
            HttpSession sesion = request.getSession(false); // Captura la sesion actual si existe
            if (sesion != null) {
                sesion.removeAttribute("rol"); // Borra el rol de admin
                sesion.invalidate();           // Destruye la sesión por completo en el servidor
            }
            // Redirige al login, pero ahora con la sesión completamente muerta
            response.sendRedirect("PagLogin.jsp"); 
            return;
        }

        switch (accion) {
            case "login":
                Login(request, response);
                break;
            case "autentificarse":
                Autentificarse(request, response);
                break;
            case "logout":
                Logout(request, response);
                break;
            default:
                response.sendRedirect(pagLogin);
                break;
        }
    }

    protected void Autentificarse(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String correo = request.getParameter("correo");
    String password = request.getParameter("contrasena");

        if (correo == null || correo.trim().isEmpty() || password == null || password.isEmpty()) {
            request.getSession().setAttribute("error", "Debes ingresar correo y contraseña.");
            request.getRequestDispatcher(pagLogin).forward(request, response);
            return;
        }

        // Un solo camino de login contra la tabla clientes (admin y usuario están
        // en la misma tabla, diferenciados por la columna "rol"). Ya no hay
        // credenciales de admin quemadas en código.
        Cliente obj = authDao.Login(correo.trim(), password);

        if (obj == null) {
            request.getSession().setAttribute("error", "Correo y/o contraseña incorrecta");
            request.getRequestDispatcher(pagLogin).forward(request, response);
            return;
        }

        HttpSession sesion = request.getSession();
        sesion.setAttribute("rol", obj.getRol());   // "admin" o "usuario", tal cual viene de BD

        if ("admin".equals(obj.getRol())) {
            sesion.setAttribute("nombre", obj.getNombres());
            response.sendRedirect("AdminDashboardControlador");
        } else {
            sesion.setAttribute("usuario", obj);
            response.sendRedirect("InicioControlador");
        }
    }

    protected void Login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(pagLogin).forward(request, response);
    }

    protected void Logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getSession().invalidate();
        response.sendRedirect("InicioControlador");
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
        return "Auth controlador de login";
    }
}

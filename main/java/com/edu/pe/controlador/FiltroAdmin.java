package com.edu.pe.controlador;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


/**
 * Filtro de seguridad: bloquea el acceso al panel administrativo
 * a cualquiera que no tenga sessionScope.rol == "admin".
 * Cubre RNF02.3 (protección contra accesos no autorizados).
 */
@WebFilter(urlPatterns = {
    "/AdminProductoControlador",
    "/AdminCategoriaControlador",
    "/AdminClienteControlador",
    "/AdminDashboardControlador",
    "/AdminPedidoControlador"
})
public class FiltroAdmin implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession sesion = req.getSession(false);

        boolean esAdmin = sesion != null && "admin".equals(sesion.getAttribute("rol"));

        if (esAdmin) {
            chain.doFilter(request, response);
        } else {
            req.getSession().setAttribute("error", "Debes iniciar sesión como administrador para acceder a esta sección.");
            resp.sendRedirect(req.getContextPath() + "/AuthControlador?accion=login");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void destroy() {}
}

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    Sidebar fijo para el panel administrativo.
    IMPORTANTE: este archivo ya NO debe traer <link> de Bootstrap/Fuentes/CSS.
    Esos van únicamente en el <head> de cada página que lo incluye.
--%>
<style>
    .admin-body {
        margin: 0;
        background: #f4f6f9;
    }
    .admin-sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 240px;
        height: 100vh;
        background: var(--fp-verde-oscuro, #4F6B54);
        color: #fff;
        display: flex;
        flex-direction: column;
        z-index: 1000;
        overflow-y: auto;
    }
    .admin-sidebar .marca {
        padding: 1.2rem 1rem;
        font-family: 'Playfair Display', serif;
        font-weight: 700;
        font-size: 1.15rem;
        border-bottom: 1px solid rgba(255,255,255,.15);
        display: flex;
        align-items: center;
        gap: .5rem;
    }
    .admin-sidebar .nav-link {
        color: rgba(255,255,255,.85);
        padding: .75rem 1.2rem;
        display: flex;
        align-items: center;
        gap: .7rem;
        border-left: 4px solid transparent;
        transition: background .15s, border-color .15s;
    }
    .admin-sidebar .nav-link:hover {
        background: rgba(255,255,255,.08);
        
    }
    .admin-sidebar .nav-link.active {
        background: rgba(255,255,255,.12);
        border-left-color: var(--fp-dorado, #D9A24B);
        color: #fff;
        font-weight: 600;
    }
    .admin-sidebar .nav-link i {
        width: 20px;
        text-align: center;
    }
    .admin-sidebar .salir {
        margin-top: auto;
        border-top: 1px solid rgba(255,255,255,.15);
        
    }
    .admin-content {
        margin-left: 240px;
        padding: 1.75rem;
        min-height: 100vh;
        
    }
    @media (max-width: 768px) {
        .admin-sidebar { width: 100%; height: auto; position: relative; }
        .admin-content { margin-left: 0; }
    }
</style>

<nav class="admin-sidebar">
    <div class="marca">
        <i class="fa fa-spa"></i> Florería Primavera
    </div>
    <a class="nav-link ${param.activo == 'dashboard' ? 'active' : ''}" href="AdminDashboardControlador">
        <i class="fa-solid fa-chart-line"></i> Dashboard
    </a>
    <a class="nav-link ${param.activo == 'productos' ? 'active' : ''}" href="AdminProductoControlador?accion=listar">
        <i class="fa-solid fa-seedling"></i> Productos
    </a>
    <a class="nav-link ${param.activo == 'pedidos' ? 'active' : ''}" href="AdminPedidoControlador?accion=listar">
        <i class="fa-solid fa-receipt"></i> Pedidos
    </a>
    <a class="nav-link ${param.activo == 'categorias' ? 'active' : ''}" href="AdminCategoriaControlador?accion=listar">
        <i class="fa-solid fa-tags"></i> Categorías
    </a>
    <a class="nav-link ${param.activo == 'clientes' ? 'active' : ''}" href="AdminClienteControlador?accion=listar">
        <i class="fa fa-users"></i> Clientes
    </a>
    <div class="salir">
        <a class="nav-link" href="InicioControlador">
            <i class="fa fa-store"></i> Ver Tienda
        </a>
        <a class="nav-link" href="AuthControlador?accion=logout">
            <i class="fa fa-sign-out-alt"></i> Cerrar Sesión
        </a>
    </div>
</nav>
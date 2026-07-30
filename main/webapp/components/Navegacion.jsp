
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<nav class="navbar navbar-expand-lg" style="background-color: #f8d7da ">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <img src="assets/img/recursos/logo.png" alt="logo" style="width: 50px; height: auto; "/>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link text-white" aria-current="page" href="InicioControlador">
                        <i class="fas fa-home"></i> Catálogo
                    </a>
                </li>                   
                <li class="nav-item">
                    <a class="nav-link text-white" href="CarritoControlador?accion=listar">
                        <i class="fas fa-shopping-cart"></i> 
                        (<span class="fw-bold">${sessionScope.carrito != null? sessionScope.carrito.size(): 0}</span>) 
                        Carrito
                    </a>
                </li>
                
                <%-- SOLO SE MUESTRA SI ES ADMIN --%>
                <c:if test="${sessionScope.rol == 'admin'}">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="AdminProductoControlador?accion=listar">
                            <i class="fas fa-tools"></i> Panel Administrativo
                        </a>
                    </li>
                </c:if>
                    
                <c:if test="${sessionScope.usuario != null}">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="PedidoControlador?accion=mis_pedidos">
                            <i class="fas fa-receipt"></i> Mis Pedidos
                        </a>
                    </li>
                </c:if>         
            </ul>
                        
            <form class="d-flex align-items-center" >               
                
                <%-- Si no hay nadie logueado (ni admin ni cliente) --%>
                <c:if test="${sessionScope.usuario == null && sessionScope.rol == null}">
                    <a href="ClienteControlador?accion=nuevo" class="btn btn-dark">
                        <i class="fas fa-user-plus"></i> Registrarse
                    </a>
                    &nbsp;
                    <a href="AuthControlador?accion=login" class="btn btn-dark">
                        <i class="fas fa-user-lock"></i> Inicia Sesión
                    </a>
                </c:if>

                <%-- Si el logueado es un CLIENTE --%>
                <c:if test="${sessionScope.usuario != null}">
                    <span class="navbar-tex me-2">
                        <i class="fa fa-user"></i>Hola, ${sessionScope.usuario.nombresCompletos}
                    </span>
                    &nbsp;
                    <a href="AuthControlador?accion=logout" class="btn btn-dark">
                        <i class="fa fa-sign-out-alt"></i> Salir
                    </a>
                </c:if>

                <%-- Si el logueado es un ADMIN --%>
                <c:if test="${sessionScope.rol == 'admin'}">
                    <span class="navbar-text me-2">
                        <i class="fa fa-user-shield"></i> ADMINISTRADOR: Hola, ${sessionScope.nombre}
                    </span>
                    &nbsp;
                    <a href="AuthControlador?accion=logout" class="btn btn-dark">
                        <i class="fa fa-sign-out-alt"></i> Salir Admin
                    </a>
                </c:if>
                
               

            </form>
        </div>
    </div>
</nav>

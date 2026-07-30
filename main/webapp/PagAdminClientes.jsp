<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="es">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Panel Admin - Clientes</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link href="assets/css/estilos.css" rel="stylesheet" type="text/css"/>
        <style>
            .card-shadow {
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            }
        </style>
    </head>
    <body class="admin-body">
        <jsp:include page="components/AdminSidebar.jsp">
            <jsp:param name="activo" value="clientes" />
        </jsp:include>
        <jsp:include page="components/Mensaje.jsp" />

        <div class="admin-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">
                    <i class="fa fa-users me-2"></i> Clientes Registrados
                </h2>
                <span class="badge bg-fp-rosa-oscuro fs-6">
                    Total: ${listaClientes.size()} clientes
                </span>
            </div>

            <div class="card card-shadow">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty listaClientes}">
                            <div class="text-center py-5">
                                <i class="fa fa-user-slash fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">No hay clientes registrados todavía</h4>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover table-striped mb-0 align-middle">
                                    <thead class="table-dark">
                                        <tr>
                                            <th class="text-center" width="60">ID</th>
                                            <th class="text-center">Nombre completo</th>
                                            <th class="text-center">Correo</th>
                                            <th class="text-center">Teléfono</th>
                                            <th class="text-center">Distrito</th>
                                            <th class="text-center">Rol</th>
                                            <th class="text-center">Fecha de registro</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="cli" items="${listaClientes}">
                                            <tr>
                                                <td class="text-center fw-bold">${cli.idCliente}</td>
                                                <td class="fw-semibold">${cli.nombres} ${cli.apellidos}</td>
                                                <td>${cli.correo}</td>
                                                <td>${cli.telefono}</td>
                                                <td>${cli.distrito}</td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${cli.rol == 'admin'}">
                                                            <span class="badge bg-dark">Admin</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-fp-verde text-white">Cliente</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty cli.fechaRegistro}">
                                                        ${cli.fechaRegistro.dayOfMonth}/${cli.fechaRegistro.monthValue}/${cli.fechaRegistro.year}
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                setTimeout(function () {
                    document.querySelectorAll('.alert').forEach(function (alert) {
                        new bootstrap.Alert(alert).close();
                    });
                }, 5000);
            });
        </script>
    </body>
</html>

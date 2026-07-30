
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Historial de Pedidos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" 
              rel="stylesheet" 
              integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" 
              crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" 
              integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" 
              crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link href="assets/css/estilos.css" rel="stylesheet" type="text/css"/>
        
    </head>
    <body>
        <!-- Menú de navegación -->
        <jsp:include page="components/Navegacion.jsp" />
        <jsp:include page="components/Mensaje.jsp"/>


        <!-- Contenedor de carrito -->
        <div class="container py-4">
            <h4>🌸 Historial de Pedidos</h4>
            <hr>
            <div class="row">
                <!-- Tabla de productos -->
                <div class="col-sm-12">
                    <div class="card">
                        <div class="card-body">
                            <table class="table table-bordered table-striped align-middle">
                                <thead class="text-white">
                                    <tr>
                                        <th># Pedido</th>
                                        <th>Fecha</th>
                                        <th>Total (S/)</th>
                                        <th>Estado</th>
                                        <th>Detalle</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${pedidos}" var="item">
                                        <tr>
                                            <td>${item.idPedido}</td>
                                            <td>${item.fecha}</td>
                                            <td>${item.total}</td>
                                            <td>${item.estado}</td>
                                            <td>
                                                <button type="button" class="btn btn-info btn-sm"
                                                        data-bs-toggle="modal" data-bs-target="#modalDetalle_${item.idPedido}">
                                                    Ver
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
                            <%-- Modales de detalle: FUERA de la tabla, uno por pedido --%>
                            <c:forEach items="${pedidos}" var="item">
                                <div class="modal fade" id="modalDetalle_${item.idPedido}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h1 class="modal-title fs-5">::: Pedido #${item.idPedido} :::</h1>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <table class="table table-bordered table-striped align-middle">
                                                    <thead class="text-white">
                                                        <tr>
                                                            <th>Imagen</th>
                                                            <th>Producto</th>
                                                            <th>Precio (S/)</th>
                                                            <th>Cantidad</th>
                                                            <th>Importe (S/)</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${item.detalles}" var="detalle">
                                                            <tr>
                                                                <td class="text-center">
                                                                    <img src="assets/img/floreria/${detalle.producto.imagen}"
                                                                         width="50" height="60"
                                                                         alt="${detalle.producto.nombre}"/>
                                                                </td>
                                                                <td>${detalle.producto.nombre}
                                                                    <c:if test="${not empty detalle.dedicatoria}">
                                                                        <div class="mt-1 text-muted small fst-italic">
                                                                            ✉️ "${detalle.dedicatoria}"
                                                                        </div>
                                                                    </c:if>
                                                                </td>
                                                                <td>S/ ${detalle.producto.precio}</td>
                                                                <td>${detalle.cantidad}</td>
                                                                <td>S/ ${detalle.importe}</td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>

                                                <div class="mt-2 small text-muted">
                                                    <strong>Dirección de entrega:</strong> ${item.direccionEntrega}<br>
                                                    <strong>Método de pago:</strong> ${item.metodoPago}
                                                </div>

                                                <c:if test="${not empty item.comprobantePago}">
                                                    <div class="mt-3 text-center">
                                                        <p class="fw-bold mb-1"><i class="fa fa-image text-success"></i> Comprobante de pago:</p>
                                                        <img src="imagenes/comprobantes/${item.comprobantePago}"
                                                             class="img-thumbnail"
                                                             style="max-height: 220px;"
                                                             alt="Comprobante de pago ${item.idPedido}">
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            
        <!-- Scripts Bootstrap -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

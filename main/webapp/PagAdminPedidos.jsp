
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="es">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Panel Admin - Pedidos</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link href="assets/css/estilos.css" rel="stylesheet" type="text/css"/>
        <style>
            .card-shadow {
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            }
            .badge-estado {
                font-size: .8em;
                padding: 5px 10px;
            }
            .detalle-row {
                display: none;
                background: #f8f9fa;
            }
            .btn-ver-detalle {
                cursor: pointer;
            }
            select.select-estado {
                font-size: .85rem;
                min-width: 140px;
            }
        </style>
    </head>
    <body class="admin-body">
        <jsp:include page="components/AdminSidebar.jsp">
            <jsp:param name="activo" value="pedidos" />
        </jsp:include>
        <jsp:include page="components/Mensaje.jsp" />

        <div class="admin-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">
                    <i class="fa fa-receipt me-2"></i> Administración de Pedidos
                </h2>
                <span class="badge bg-fp-rosa-oscuro fs-6">
                    Total: ${listaPedidos.size()} pedidos
                </span>
            </div>

            <div class="card card-shadow">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty listaPedidos}">
                            <div class="text-center py-5">
                                <i class="fa fa-inbox fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">No hay pedidos registrados todavía</h4>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover table-striped mb-0 align-middle">
                                    <thead class="table-dark">
                                        <tr>
                                            <th class="text-center">#</th>
                                            <th>Cliente</th>
                                            <th>Fecha</th>
                                            <th class="text-center">Total</th>
                                            <th>Pago</th>
                                            <th>Dirección de entrega</th>
                                            <th class="text-center">Estado</th>
                                            <th class="text-center">Detalle</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="ped" items="${listaPedidos}" varStatus="st">
                                            <tr>
                                                <td class="text-center fw-bold">${ped.idPedido}</td>
                                                <td>${ped.nombreCliente}</td>
                                                <td>${ped.fechaFormateada}</td>
                                                <td class="text-center fw-bold text-success">S/ ${ped.total}</td>
                                                <td>
                                                    <span class="badge bg-fp-rosa">${ped.metodoPago}</span>
                                                </td>
                                                <td><small>${ped.direccionEntrega}</small></td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${ped.estado == 'Pendiente'}">
                                                            <span class="badge badge-estado bg-warning text-dark">⏳ Pendiente</span>
                                                        </c:when>
                                                        <c:when test="${ped.estado == 'Preparando'}">
                                                            <span class="badge badge-estado bg-info text-dark">🧁 Preparando</span>
                                                        </c:when>
                                                        <c:when test="${ped.estado == 'Enviado'}">
                                                            <span class="badge badge-estado bg-primary">🚚 Enviado</span>
                                                        </c:when>
                                                        <c:when test="${ped.estado == 'Entregado'}">
                                                            <span class="badge badge-estado bg-success">✅ Entregado</span>
                                                        </c:when>
                                                        <c:when test="${ped.estado == 'Cancelado'}">
                                                            <span class="badge badge-estado bg-danger">❌ Cancelado</span>
                                                        </c:when>
                                                    </c:choose>

                                                    <div class="mt-2">
                                                        <select class="form-select form-select-sm select-estado"
                                                                onchange="if(confirm('¿Cambiar el estado del pedido #${ped.idPedido} a ' + this.value + '?')) { window.location.href='AdminPedidoControlador?accion=cambiarEstado&id=${ped.idPedido}&estado=' + this.value; } else { this.value='${ped.estado}'; }">
                                                            <option value="Pendiente"  ${ped.estado == 'Pendiente'  ? 'selected' : ''}>Pendiente</option>
                                                            <option value="Preparando" ${ped.estado == 'Preparando' ? 'selected' : ''}>Preparando</option>
                                                            <option value="Enviado"    ${ped.estado == 'Enviado'    ? 'selected' : ''}>Enviado</option>
                                                            <option value="Entregado"  ${ped.estado == 'Entregado'  ? 'selected' : ''}>Entregado</option>
                                                            <option value="Cancelado"  ${ped.estado == 'Cancelado'  ? 'selected' : ''}>Cancelado</option>
                                                        </select>
                                                    </div>
                                                </td>
                                                <td class="text-center">
                                                    <button type="button" class="btn btn-outline-primary btn-sm btn-ver-detalle"
                                                            onclick="toggleDetalle(${st.index})">
                                                        <i class="fa fa-eye"></i> Ver
                                                    </button>
                                                </td>
                                            </tr>
                                            <tr class="detalle-row" id="detalle-${st.index}">
                                                <td colspan="8">
                                                    <strong>Productos del pedido #${ped.idPedido}:</strong>
                                                    <table class="table table-sm table-bordered mt-2 mb-0 bg-white">
                                                        <thead>
                                                            <tr>
                                                                <th>Producto</th>
                                                                <th class="text-center">Cantidad</th>
                                                                <th class="text-center">Precio Unit.</th>
                                                                <th class="text-center">Importe</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="det" items="${ped.detalles}">
                                                                <tr>
                                                                    <td>${det.producto.nombre}
                                                                        <c:if test="${not empty det.dedicatoria}">
                                                                            <div class="mt-1 text-primary small fst-italic">
                                                                                ✉️ "${det.dedicatoria}"
                                                                            </div>
                                                                        </c:if>
                                                                    </td>
                                                                    <td class="text-center">${det.cantidad}</td>
                                                                    <td class="text-center">S/ ${det.precioUnitario}</td>
                                                                    <td class="text-center">S/ ${det.importe}</td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                    <c:if test="${not empty ped.observaciones}">
                                                        <div class="mt-2"><strong>Observaciones:</strong> ${ped.observaciones}</div>
                                                    </c:if>

                                                    <%-- Datos de envío resumidos --%>
                                                    <div class="mt-2 p-2 bg-light rounded border">
                                                        <div><i class="fa fa-map-marker-alt text-primary"></i> <strong>Dirección de entrega:</strong> ${ped.direccionEntrega}</div>
                                                        <div class="mt-1"><i class="fa fa-wallet text-success"></i> <strong>Método de pago:</strong> ${ped.metodoPago}</div>
                                                    </div>

                                                    <%-- Comprobante de pago: miniatura clicable + botón descargar --%>
                                                    <c:choose>
                                                        <c:when test="${not empty ped.comprobantePago}">
                                                            <div class="mt-3">
                                                                <strong><i class="fa fa-file-image text-success"></i> Comprobante de pago:</strong>
                                                                <div class="d-flex align-items-center gap-3 mt-2">
                                                                    <%-- Miniatura clicable que abre el modal --%>
                                                                    <img src="assets/img/comprobantes/${ped.comprobantePago}"
                                                                         class="img-thumbnail"
                                                                         style="max-height:90px; cursor:pointer; border: 2px solid #198754;"
                                                                         alt="Comprobante pedido #${ped.idPedido}"
                                                                         title="Clic para ver en grande"
                                                                         onclick="verComprobante('assets/img/comprobantes/${ped.comprobantePago}', ${ped.idPedido})">
                                                                    <div class="d-flex flex-column gap-1">
                                                                        <button type="button" class="btn btn-outline-primary btn-sm"
                                                                                onclick="verComprobante('assets/img/comprobantes/${ped.comprobantePago}', ${ped.idPedido})">
                                                                            <i class="fa fa-search-plus"></i> Ver grande
                                                                        </button>
                                                                        <a href="assets/img/comprobantes/${ped.comprobantePago}"
                                                                           download="comprobante-pedido-${ped.idPedido}"
                                                                           class="btn btn-outline-success btn-sm">
                                                                            <i class="fa fa-download"></i> Descargar
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="mt-2 text-muted small">
                                                                <i class="fa fa-exclamation-circle"></i> Sin comprobante adjunto
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
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

        <%-- Modal para ver el comprobante en tamaño completo --%>
        <div class="modal fade" id="modalComprobante" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-dark text-white">
                        <h5 class="modal-title" id="tituloModalComprobante">
                            <i class="fa fa-file-image"></i> Comprobante de pago
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center bg-secondary p-3">
                        <img id="imgComprobante" src="" alt="Comprobante"
                             style="max-width:100%; max-height:75vh; border-radius:4px; box-shadow: 0 4px 12px rgba(0,0,0,.4);">
                    </div>
                    <div class="modal-footer">
                        <a id="btnDescargarComprobante" href="#" download=""
                           class="btn btn-success">
                            <i class="fa fa-download"></i> Descargar comprobante
                        </a>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function toggleDetalle(indice) {
                var fila = document.getElementById('detalle-' + indice);
                fila.style.display = (fila.style.display === 'table-row') ? 'none' : 'table-row';
            }

            function verComprobante(rutaImg, idPedido) {
                document.getElementById('imgComprobante').src = rutaImg;
                document.getElementById('tituloModalComprobante').innerHTML =
                    '<i class="fa fa-file-image"></i> Comprobante — Pedido #' + idPedido;
                document.getElementById('btnDescargarComprobante').href = rutaImg;
                document.getElementById('btnDescargarComprobante').download = 'comprobante-pedido-' + idPedido;

                new bootstrap.Modal(document.getElementById('modalComprobante')).show();
            }

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

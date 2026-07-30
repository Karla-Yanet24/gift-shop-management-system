
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="es">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Panel Admin - Dashboard</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link href="assets/css/estilos.css" rel="stylesheet" type="text/css"/>
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
        <style>
            .card-shadow {
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            }
            .kpi-card {
                border-radius: 12px;
                color: #fff;
                padding: 1.4rem;
                display: flex;
                flex-direction: column;
                gap: .3rem;
            }
            .kpi-card .kpi-icon {
                font-size: 1.8rem;
                opacity: .85;
            }
            .kpi-card .kpi-valor {
                font-size: 1.9rem;
                font-weight: 700;
            }
            .kpi-card .kpi-label {
                font-size: .9rem;
                opacity: .9;
            }
            .kpi-ventas      { background: linear-gradient(135deg, #4F6B54, #6B8F71); } /* verde oscuro → verde salvia */
            .kpi-pendientes  { background: linear-gradient(135deg, #B5802E, #D9A24B); }  /* dorado oscuro → dorado */
            .kpi-clientes    { background: linear-gradient(135deg, #C97B95, #E8AABF); }  /* rosa oscuro → rosa pétalo */
            .kpi-productos   { background: linear-gradient(135deg, #8C5E52, #B98074); }  /* terracota — cuarto tono cálido a juego con flores/tierra */

            .stock-bajo-row { background: #fff3cd; }
        </style>
    </head>
    <body class="admin-body">
        <jsp:include page="components/AdminSidebar.jsp">
            <jsp:param name="activo" value="dashboard" />
        </jsp:include>
        <jsp:include page="components/Mensaje.jsp" />

        <div class="admin-content">
            <h2 class="mb-4">
                <i class="fa fa-chart-line me-2"></i> Dashboard
            </h2>

            <!-- Tarjetas KPI -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="kpi-card kpi-ventas">
                        <i class="fa fa-sack-dollar kpi-icon"></i>
                        <span class="kpi-valor">S/ ${ventasTotales}</span>
                        <span class="kpi-label">Ventas totales (${totalPedidos} pedidos)</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="kpi-card kpi-pendientes">
                        <i class="fa fa-clock kpi-icon"></i>
                        <span class="kpi-valor">${pedidosPendientes}</span>
                        <span class="kpi-label">Pedidos pendientes</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="kpi-card kpi-clientes">
                        <i class="fa fa-users kpi-icon"></i>
                        <span class="kpi-valor">${totalClientes}</span>
                        <span class="kpi-label">Clientes registrados</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="kpi-card kpi-productos">
                        <i class="fa fa-seedling kpi-icon"></i>
                        <span class="kpi-valor">${totalProductos}</span>
                        <span class="kpi-label">Productos activos</span>
                    </div>
                </div>
            </div>

            <div class="row g-3">
                <!-- Gráfico de pedidos por estado -->
                <div class="col-md-7">
                    <div class="card card-shadow h-100">
                        <div class="card-header bg-white">
                            <strong><i class="fa fa-chart-column me-2"></i>Pedidos por estado</strong>
                        </div>
                        <div class="card-body">
                            <canvas id="chartEstados" height="220"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Alerta de stock bajo -->
                <div class="col-md-5">
                    <div class="card card-shadow h-100">
                        <div class="card-header bg-white">
                            <strong><i class="fa fa-triangle-exclamation me-2 text-warning"></i>
                                Stock bajo (≤ ${umbralStockBajo} unidades)</strong>
                        </div>
                        <div class="card-body p-0" style="max-height: 320px; overflow-y: auto;">
                            <c:choose>
                                <c:when test="${empty productosStockBajo}">
                                    <div class="text-center text-muted py-4">
                                        <i class="fa fa-circle-check fa-2x text-success mb-2"></i>
                                        <p class="mb-0">Todo el stock está en buen nivel.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table class="table table-sm table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Producto</th>
                                                <th class="text-center">Stock</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="p" items="${productosStockBajo}">
                                                <tr class="stock-bajo-row">
                                                    <td>${p.nombre}</td>
                                                    <td class="text-center fw-bold">
                                                        <c:choose>
                                                            <c:when test="${p.stock == 0}">
                                                                <span class="badge bg-danger">Agotado</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning text-dark">${p.stock}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Construimos las etiquetas y valores del gráfico a partir del Map
            // pedidosPorEstado que llega del servlet (orden fijo: Pendiente,
            // Preparando, Enviado, Entregado, Cancelado).
            var etiquetas = [
                <c:forEach var="entry" items="${pedidosPorEstado}" varStatus="st">
                    "${entry.key}"<c:if test="${!st.last}">,</c:if>
                </c:forEach>
            ];
            var valores = [
                <c:forEach var="entry" items="${pedidosPorEstado}" varStatus="st">
                    ${entry.value}<c:if test="${!st.last}">,</c:if>
                </c:forEach>
            ];

            var ctx = document.getElementById('chartEstados').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: etiquetas,
                    datasets: [{
                        label: 'Pedidos',
                        data: valores,
                        backgroundColor: [
                            '#E8AABF', // Pendiente (rosa pétalo)
                            '#D9A24B', // Preparando (dorado)
                            '#6B8F71', // Enviado (verde salvia)
                            '#4F6B54', // Entregado (verde oscuro)
                            '#C97B95'  // Cancelado (rosa oscuro)
                        ],
                        borderColor: [
                            '#C97B95',
                            '#C48A36',
                            '#4F6B54',
                            '#3D5642',
                            '#B56582'
                        ],
                        borderWidth: 2,
                        borderRadius: 8,
                        borderSkipped: false
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { display: false } },
                    scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
                }
            });

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

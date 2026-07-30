
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- Alerta de Éxito --%>
<c:if test="${not empty sessionScope.success}">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            Swal.fire({
                title: "¡Logrado!",
                text: "${sessionScope.success}", <%-- Las comillas son vitales aquí --%>
                icon: "success",
                confirmButtonColor: "#2C4975"
            });
        });
    </script>
    <c:remove var="success" scope="session"/>
</c:if>

<%-- Alerta de Error --%>
<c:if test="${not empty sessionScope.error}">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            Swal.fire({
                title: "Advertencia",
                text: "${sessionScope.error}", <%-- Las comillas son vitales aquí --%>
                icon: "error",
                confirmButtonColor: "#dc3545",
            });
        });
    </script>
    <c:remove var="error" scope="session"/>
</c:if>



<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="en_US"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mi Billetera Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <span class="navbar-brand fw-semibold">Mi Billetera Digital</span>
        <span class="badge bg-secondary">JSP + Servlet</span>
    </div>
</nav>

<main class="container py-4">

    <div class="row g-3 mb-4">
        <!-- Saldo disponible -->
        <div class="col-md-5">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <p class="text-uppercase text-muted small mb-1">Saldo disponible</p>
                    <h2 class="text-success fw-bold mb-1">
                        S/ <fmt:formatNumber value="${saldo}" pattern="#,##0.00"/>
                    </h2>
                    <small class="text-muted">
                        <c:choose>
                            <c:when test="${empty movimientos}">Saldo inicial</c:when>
                            <c:otherwise>Después de ${movimientos.size()} movimiento(s) válido(s)</c:otherwise>
                        </c:choose>
                    </small>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="col-md-7">
                <div class="alert alert-danger h-100 mb-0" role="alert">
                    <strong>No se registró el movimiento.</strong><br>
                    <c:out value="${error}"/>
                </div>
            </div>
        </c:if>
    </div>

    <h5 class="mb-2">Movimientos recientes</h5>
    <div class="card shadow-sm mb-4">
        <div class="table-responsive">
            <table class="table mb-0 align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Tipo</th>
                        <th>Monto (S/)</th>
                        <th>Orden</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="m" items="${movimientos}" varStatus="estado">
                        <tr>
                            <td>
                                <span class="badge ${m.tipo == 'Recarga' ? 'bg-success' : 'bg-danger'}">${m.tipo}</span>
                            </td>
                            <td class="fw-semibold ${m.tipo == 'Recarga' ? 'text-success' : 'text-danger'}">
                                ${m.tipo == 'Recarga' ? '+' : '-'} <fmt:formatNumber value="${m.monto}" pattern="#,##0.00"/>
                            </td>
                            <td class="text-muted">${estado.first ? 'Más reciente' : 'Anterior'}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty movimientos}">
                        <tr>
                            <td colspan="3" class="text-center text-muted py-3">Aún no hay movimientos</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <h5 class="card-title">Nuevo movimiento</h5>
            <form action="${pageContext.request.contextPath}/billetera" method="post" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label for="tipo" class="form-label">Tipo</label>
                    <select id="tipo" name="tipo" class="form-select">
                        <option value="Recarga" ${param.tipo == 'Gasto' ? '' : 'selected'}>Recarga</option>
                        <option value="Gasto" ${param.tipo == 'Gasto' ? 'selected' : ''}>Gasto</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="monto" class="form-label">Monto (S/)</label>
                    <input type="number" step="0.01" id="monto" name="monto" class="form-control"
                           placeholder="0.00" value="<c:out value='${param.monto}'/>">
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary w-100">Registrar movimiento</button>
                </div>
            </form>
        </div>
    </div>

</main>
</body>
</html>
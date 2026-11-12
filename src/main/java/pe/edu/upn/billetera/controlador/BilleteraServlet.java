package pe.edu.upn.billetera.controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import pe.edu.upn.billetera.modelo.Movimiento;

@WebServlet("/billetera")
public class BilleteraServlet extends HttpServlet {

    private static final double SALDO_INICIAL = 250.00;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        inicializarSesion(request.getSession());
        mostrarVista(request, response);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        inicializarSesion(session);

        double saldo = (Double) session.getAttribute("saldo");
        List<Movimiento> movimientos = (List<Movimiento>) session.getAttribute("movimientos");

        String tipo = request.getParameter("tipo");
        String montoTexto = request.getParameter("monto");


        if (!"Recarga".equals(tipo) && !"Gasto".equals(tipo)) {
            mostrarError(request, response, "Selecciona un tipo de movimiento válido.");
            return;
        }

        // 2. Validar monto vacío
        if (montoTexto == null || montoTexto.trim().isEmpty()) {
            mostrarError(request, response, "Ingresa un monto.");
            return;
        }


        double monto;
        try {
            monto = Double.parseDouble(montoTexto.trim());
        } catch (NumberFormatException e) {
            mostrarError(request, response, "El monto debe ser un número válido.");
            return;
        }
        if (Double.isNaN(monto) || Double.isInfinite(monto)) {
            mostrarError(request, response, "El monto debe ser un número válido.");
            return;
        }

        monto = Math.round(monto * 100) / 100.0;

        if (monto <= 0) {
            mostrarError(request, response, "El monto debe ser mayor que cero.");
            return;
        }

        if ("Gasto".equals(tipo) && monto > saldo) {
            mostrarError(request, response,
                    "Saldo insuficiente. Gasto solicitado: S/ " + formato(monto)
                    + " - Saldo disponible: S/ " + formato(saldo));
            return;
        }

        if ("Recarga".equals(tipo)) {
            saldo = saldo + monto;
        } else {
            saldo = saldo - monto;
        }
        saldo = Math.round(saldo * 100) / 100.0;

        session.setAttribute("saldo", saldo);
        movimientos.add(0, new Movimiento(tipo, monto)); 

        response.sendRedirect(request.getContextPath() + "/billetera");
    }

    private void inicializarSesion(HttpSession session) {
        if (session.getAttribute("saldo") == null) {
            session.setAttribute("saldo", SALDO_INICIAL);
            session.setAttribute("movimientos", new ArrayList<Movimiento>());
        }
    }

    private void mostrarVista(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        request.setAttribute("saldo", session.getAttribute("saldo"));
        request.setAttribute("movimientos", session.getAttribute("movimientos"));
        request.getRequestDispatcher("/WEB-INF/views/billetera.jsp").forward(request, response);
    }

    private void mostrarError(HttpServletRequest request, HttpServletResponse response, String mensaje)
            throws ServletException, IOException {

        request.setAttribute("error", mensaje);
        mostrarVista(request, response);
    }

    private String formato(double valor) {
        return String.format(Locale.US, "%.2f", valor);
    }
}

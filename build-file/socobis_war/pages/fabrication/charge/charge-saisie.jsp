<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    String idFab = request.getParameter("id");
    if (idFab != null && !idFab.isEmpty()) {
        request.setAttribute("id", idFab);
        RequestDispatcher dispatcher = request.getRequestDispatcher("fabrication/charge/charge-saisie-multiple.jsp");
        dispatcher.include(request, response);
    }
%>
<%@page import="faturefournisseur.As_BonDeCommande"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@page import="java.sql.Date"%>
<%@page import="java.util.Enumeration"%>
<%
    boolean needsConfirmation = false;
    try {
        UserEJB u = (UserEJB) session.getValue("u");
        String lien = (String) session.getValue("lien");

        String idbc = request.getParameter("idbc");
        String datyStr = request.getParameter("daty");

        if (idbc != null && idbc.startsWith("BC")
                && datyStr != null && !datyStr.isEmpty()) {

            Date dateReception = Utilitaire.stringDate(datyStr);
            As_BonDeCommande bc = new As_BonDeCommande();
            bc = bc.getAS_BonDommance_By_ID(idbc, null);

            if (bc != null && bc.getDateLimite() != null && dateReception != null) {
                needsConfirmation = !bc.getDateLimite().equals(dateReception);
            }
        }

        StringBuilder hiddenFields = new StringBuilder();
        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String param = params.nextElement();
            String[] values = request.getParameterValues(param);
            for (String value : values) {
                String safeValue = value != null ? value.replace("\"", "&quot;") : "";
                hiddenFields.append("<input type='hidden' name='")
                        .append(param).append("' value='")
                        .append(safeValue).append("'/>\n");
            }
        }

        String targetUrl = lien + "?but=apresMultiple.jsp";
%>

<form id="continueForm" method="post" action="<%=targetUrl%>">
    <%=hiddenFields.toString()%>
</form>

<script type="text/javascript">
    window.onload = function() {
        <% if (needsConfirmation) { %>
        var result = confirm("La date de r\u00e9ception est diff\u00e9rente de la date pr\u00e9visionnelle de livraison dans le bon de commande. Voulez-vous continuer quand m\u00eame ?");
        if (result) {
            document.getElementById('continueForm').submit();
        } else {
            history.back();
        }
        <% } else { %>
        document.getElementById('continueForm').submit();
        <% } %>
    };
</script>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script type="text/javascript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% } %>
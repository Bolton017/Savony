
<%
    String lien = (String) session.getValue("lien");
    String id = request.getParameter("idOrigine");
    if(id == null) id = "";

    String but = "";
    if(id.startsWith("VNT")){
        but = "vente/vente-fiche.jsp&id=" + id;
    }else if (id.startsWith("FCF")){
        but = "facturefournisseur/facturefournisseur-fiche.jsp&id=" + id;
    } else if (id.startsWith("BC")) {
        but = "bondecommande/bondecommande-fiche.jsp&id=" + id;
    } else if (id.startsWith("RPRC")) {
        but = "caisse/report/reportCaisse-fiche.jsp&id=" + id;
    } else if (id.startsWith("AVR")) {
        but = "avoir/avoirFC-fiche.jsp&id=" + id;
    } else if (id.startsWith("CL")) {
        but = "client/client-fiche.jsp?id=" + id;
    } else if (id.startsWith("FRN")) {
        but = "fournisseur/fournisseur-fiche.jsp&id=" + id;
    }

    String url = lien + "?but=" + but;
%>
<script>
    window.location.href = "<%=url%>";
</script>

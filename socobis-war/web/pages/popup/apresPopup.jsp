<%@page import="utilitaire.Utilitaire"%>
<html>
<%
    String champRet =(String) request.getParameter("champReturn");
    String champUrl = (String) request.getParameter("champUrl");
    String[] champs = Utilitaire.split(champRet, ";");
    String[] champsLien = Utilitaire.split(champUrl, ";");
%>
<script language="JavaScript">
    function remplirChampOpener(nom, valeur) {
        if (!window.opener) return;
        var doc = window.opener.document;
        var champ = doc.getElementById(nom) || doc.getElementsByName(nom)[0];
        if (champ) {
            champ.value = valeur;
        }
    }
    <%for(int i =0;i<champs.length && i<champsLien.length;i++){
           if(champs[i]!=null && champs[i].compareTo("")!=0){
               String valeur = Utilitaire.champNull(request.getParameter(champsLien[i]));
               valeur = valeur.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", "").replace("\n", "\\n");
        %>
    remplirChampOpener("<%=champs[i]%>", "<%=valeur%>");
    <%}}%>
    window.close();
</script>
</html>

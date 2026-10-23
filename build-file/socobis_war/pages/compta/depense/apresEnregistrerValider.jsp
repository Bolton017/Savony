<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.*" %>
<%@ page import="produits.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.DepenseSaisie" %>
<%@ page import="faturefournisseur.DepenseFilleSaisie" %>

<%  try {
    String[] tId;
    String nomtable = request.getParameter("nomtable");
    String lien = (String) session.getValue("lien");
    UserEJB u = (UserEJB) session.getAttribute("u");
    String acte = request.getParameter("acte");
    String bute = request.getParameter("bute");
    String classe = request.getParameter("classe");
    tId = request.getParameterValues("ids");
    String idmere = "";
    String classefille = request.getParameter("classefille");
    ClassMAPTable mere = null;
    ClassMAPTable fille = null;
    Object temp = null;
    String nombreDeLigne = request.getParameter("nombreLigne");
    int nbLine = Utilitaire.stringToInt(nombreDeLigne);

    if (acte != null && acte.compareToIgnoreCase("insert") == 0) {
        mere = (ClassMAPTable) (Class.forName(classe).newInstance());
        fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
        PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
        DepenseSaisie facture = (DepenseSaisie)p.getObjectAvecValeur();
        DepenseFilleSaisie[] cfille = (DepenseFilleSaisie[]) p.getObjectFilleAvecValeur();
        facture.setFille(cfille);
        String o = facture.creerViserValider(null,u.getUser().getTuppleID());
        temp = (Object) o;
        if (o != null) {
            idmere = o;
        } %>
        <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
    <% }

} catch (Exception e) {
    e.printStackTrace(); %>
    <script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");history.back();</script>
<% } %>
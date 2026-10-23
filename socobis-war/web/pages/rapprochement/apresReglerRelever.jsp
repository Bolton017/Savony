<%@page import="user.UserEJB"%>
<%@ page import="bean.ClassMAPTable" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="faturefournisseur.FactureFournisseur" %>
<%@ page import="faturefournisseur.FactureFournisseurDetails" %>
<%@ page import="vente.Vente" %>
<%@ page import="vente.VenteDetails" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% try{
    UserEJB u = (UserEJB)session.getAttribute("u");
    String lien = (String)session.getAttribute("lien");
    String acte = request.getParameter("acte");
    String bute = request.getParameter("bute");
    String nomtable = request.getParameter("nomtable");
    String classe = request.getParameter("classe");
    String classefille = request.getParameter("classefille");
    ClassMAPTable mere = null;
    ClassMAPTable fille = null;
    String nombreDeLigne = request.getParameter("nombreLigne");
    int nbLine = Utilitaire.stringToInt(nombreDeLigne);
    String[] ids = request.getParameterValues("idsRelever");
    String[] tId = request.getParameterValues("ids");

    if (acte != null && acte.compareToIgnoreCase("debit") == 0) {
        mere = (ClassMAPTable) (Class.forName(classe).newInstance());
        fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
        PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
        FactureFournisseur cmere = (FactureFournisseur) p.getObjectAvecValeur();
        FactureFournisseurDetails[] cfille = (FactureFournisseurDetails[]) p.getObjectFilleAvecValeur();
        for (FactureFournisseurDetails classMAPTable : cfille) {
            classMAPTable.setNomTable(nomtable);
        }
        cmere.setFille(cfille);
        cmere.setEtat(1);
        FactureFournisseur fact = cmere.reglerReleverDebit(u.getUser().getTuppleID(),null,ids) ;
        //bute += "&id="+fact.getId();
%>
        <script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
    <% }
        if (acte != null && acte.compareToIgnoreCase("credit") == 0) {
            mere = (ClassMAPTable) (Class.forName(classe).newInstance());
            fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
            PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
            Vente cmere = (Vente) p.getObjectAvecValeur();
            cmere.setNomTable("VENTE");
            VenteDetails[] cfille = (VenteDetails[]) p.getObjectFilleAvecValeur();
            for (VenteDetails classMAPTable : cfille) {
                classMAPTable.setNomTable(nomtable);
            }
            cmere.setFille(cfille);
            cmere.setEtat(1);
            Vente fact = cmere.reglerReleverCredit(u.getUser().getTuppleID(),null,ids) ;
            //bute += "&id="+fact.getId();
    %>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<% }

    } catch (Exception e) {
        e.printStackTrace(); %>
        <script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
        history.back();</script>
<% } %>

<%-- 
    Document   : visa_visee_multiple
    Created on : 11 mars 2019, 18:09:26
    Author     : EBI
--%>
<%@page import="bean.ClassMAPTable"%>
<%@page import="mg.cnaps.compta.ComptaEcriture"%>
<%@page import="user.UserEJB"%>
<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="affichage.*" %>
<%@page import="paie.service.PointageService"%>
<%@ page import="java.util.Arrays" %>

<%
    String[] val = request.getParameterValues("ids");
//    String[] val = Arrays.copyOfRange(valTmp, 0, valTmp.length - 1);

    if (val == null || val.length == 0) {
        throw new Exception("Vous devez cocher au moins un element.");
    }
    String nomTableRejet = request.getParameter("nomTableRejet");
    String nomTableCategorieRejet = request.getParameter("nomTableCategorieRejet");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String lien = (String) session.getValue("lien");
    String bute = request.getParameter("bute");
    String classe = request.getParameter("classe");
    String acte = request.getParameter("acte");
    String table = request.getParameter("nomTable");
    ClassEtat t = null;
    PointageService ps = new PointageService();
    acte="viserPointageVisee";
System.out.println("table = " + table);
    try {
        //System.out.println("acte====" + acte);
        if (acte.compareToIgnoreCase("viser") == 0) {
            //System.out.println("Miditra ato");
            t = (ClassEtat) (Class.forName(classe).newInstance());
            t.setNomTable(table);
            u.viserObjectMultiple(t, val);
        }
        if (acte.compareToIgnoreCase("rejeter") == 0) {
            t = (ClassEtat) (Class.forName(classe).newInstance());
           // u.rejeterObjectMultiple(t, val, nomTableRejet, nomTableCategorieRejet);
        }
        if (acte.compareToIgnoreCase("annuler-multiple") == 0) {
            t = (ClassEtat) (Class.forName(classe).newInstance());
           // u.annulerVisaMultiple(t, val, table);
        }
        if (acte.compareToIgnoreCase("viserObjetATT") == 0) {
            //System.out.println("viserObjetATT");
            //u.viserATTObjectMultiple(val);
        }
        if (acte.compareToIgnoreCase("viserPointageVisee") == 0) {
            System.out.println("////////////////////////////   viserPointageVisee");
            ps.viserPointageVisee(val);
        }
        if(acte.compareToIgnoreCase("viserMultiple") == 0){
            if(classe.compareToIgnoreCase("mg.cnaps.paie.CongePersonnel") == 0)
                //u.viserObjectMultiple(new mg.cnaps.paie.CongePersonnel(), val);
            %><script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&etat=<%=request.getParameter("etat")%>");</script><%
        }

%><script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&table=<%=table%>");</script><%
} catch (Exception e) {
    e.printStackTrace();

%>
<script>
    alert('<%=e.getMessage()%>');
    history.back();</script>
<%
        return;
    }
%>
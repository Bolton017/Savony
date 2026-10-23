<%--
    Document   : apresMultiple
    Created on : July 03, 2025, 2:55:36 PM
    Author     : Nick Mathieu
--%>
<%@page import="constante.ConstanteEtat"%>
<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Date" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="vente.Carton" %>
<%@ page import="reservation.Reservation" %>
<%@ page import="reservation.ReservationDetails" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="stock.*" %>
<%@ page import="inventaire.Inventaire" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%!
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String nomtable = null;
    String typeBoutton;
    String ben;
    String[] tId;
%>
<%
    try {
        ben = request.getParameter("nomtable");
        nomtable = request.getParameter("nomtable");
        typeBoutton = request.getParameter("type");
        lien = (String) session.getValue("lien");
        u = (UserEJB) session.getAttribute("u");
        acte = request.getParameter("acte");
        bute = request.getParameter("bute");
        Object temp = null;
        String[] rajoutLien = null;
        String classe = request.getParameter("classe");
        ClassMAPTable t = null;
        String tempRajout = request.getParameter("rajoutLien");
        String val = "";
        String id = request.getParameter("id");
        tId = request.getParameterValues("ids");

        String nombreLigneS = request.getParameter("nombreLigne");
        int nombreLigne = Utilitaire.stringToInt(nombreLigneS);

        String idmere = request.getParameter("idmere");
        String classefille = request.getParameter("classefille");
        ClassMAPTable mere = null;
        ClassMAPTable fille = null;
        String colonneMere = request.getParameter("colonneMere");
        String nombreDeLigne = request.getParameter("nombreLigne");
        int nbLine = Utilitaire.stringToInt(nombreDeLigne);


        String rajoutLie = "";
        if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
            rajoutLien = utilitaire.Utilitaire.split(tempRajout, "-");
        }
        if (bute == null || bute.compareToIgnoreCase("") == 0) {
            bute = "pub/Pub.jsp";
        }

        if (classe == null || classe.compareToIgnoreCase("") == 0) {
            classe = "pub.Montant";
        }

        if (typeBoutton == null || typeBoutton.compareToIgnoreCase("") == 0) {
            typeBoutton = "3"; //par defaut modifier
        }

        int type = Utilitaire.stringToInt(typeBoutton);
        if (acte != null && acte.compareToIgnoreCase("ficheInventaire") == 0) {
            String [] ids = request.getParameterValues("id");
            List<EtatStockParEntree> EtatStockParEntrees = new ArrayList<>();
            System.out.println("EXPORT CSV -----");
            for (String i : ids) {
                EtatStockParEntree e = new EtatStockParEntree();
                e.setId(request.getParameter("produit_"+i));
                e.setIdMagasin(request.getParameter("idMagasin"));
                e.setIdProduitLib(request.getParameter("idProduitLib_"+i));
                e.setIdMagasinLib(request.getParameter("magasin_"+i));
                e.setIdProduit(request.getParameter("idProduit_"+i));
                if (request.getParameter("qte_"+i)!=null && request.getParameter("qte_"+i).isEmpty()==false) {
                    e.setQuantite(Double.parseDouble(request.getParameter("qte_"+i)));
                }
                if (request.getParameter("pu_"+i)!=null && request.getParameter("pu_"+i).isEmpty()==false) {
                    e.setPu(Double.parseDouble(request.getParameter("pu_"+i)));
                }
                if (request.getParameter("reste_"+i)!=null && request.getParameter("reste_"+i).isEmpty()==false) {
                    e.setReste(Double.parseDouble(request.getParameter("reste_"+i)));
                }
                EtatStockParEntrees.add(e);
            }

            Inventaire cmere = new Inventaire().genererInventaire(EtatStockParEntrees.toArray(new EtatStockParEntree[]{}));

            ClassMAPTable o = (ClassMAPTable) u.createObjectMultiple(cmere, colonneMere, cmere.getFille());
            temp = (Object) o;
            if (temp != null) {
                val = temp.toString();
                idmere = o.getTuppleID();
            }
            idmere=cmere.getId();

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
<%} %>

<%

} catch (Exception ex) {
    ex.printStackTrace();
%>
<script type="text/javascript">alert("<%=ex.getMessage()%>"); history.back();</script>
<%
        return;
    }%>
</html>

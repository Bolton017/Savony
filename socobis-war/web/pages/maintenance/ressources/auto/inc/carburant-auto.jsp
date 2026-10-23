<%@ page import="stock.*" %>
<%@ page import="affichage.*" %>
<%@ page import="maintenance.ressources.Autocarburant" %>
<% try{
    Autocarburant t = new Autocarburant();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","daty","montant","odometre","volume"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idauto='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().transformerDataString();
    //String[] lienTableau = {pr.getLien() + "?but=maintenance/configuration/attribution/attribution-liste.jsp"};
   // String[] colonneLien = {"id"};
    //pr.getTableau().setLien(lienTableau);
    //pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"ID","Date","Montant","Odom&egrave;tre","volume en (Litres)"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }
%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>


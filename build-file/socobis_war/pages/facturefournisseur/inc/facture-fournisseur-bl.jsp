
<%@page import="faturefournisseur.As_BonDeLivraison_Lib"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try{
        As_BonDeLivraison_Lib t = new As_BonDeLivraison_Lib();
        t.setNomTable("AS_BONDELIVRAISON_LIB");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","magasinlib","daty","idfournisseurlib","remarque", "etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idfacturefournisseur = '"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;

        String idDevise = (String) request.getAttribute("idDevise");
        if(idDevise==null) idDevise="Ar";
        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = {pr.getLien() + "?but=bondelivraison/bondelivraison-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setLienFille("bondelivraison/inc/bondelivraison-details.jsp&id=");
        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"ID","Magasin","Date","Fournisseur","Remarque", "&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <% }if(pr.getTableau().getHtml() == null){
    %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }
%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>



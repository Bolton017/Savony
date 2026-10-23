<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="fabrication.equipe.Equipe" %>
<%@ page import="fabrication.equipe.EquipeEmpCpl" %>

<% try{
    String id = request.getParameter("id");
    EquipeEmpCpl t = new EquipeEmpCpl();
    t.setNomTable("EQUIPE_EMP_CPL");
    String listeCrt[] = { };
    String listeInt[] = {};
    String libEntete[] = {"id", "idemploye", "nomequipe","nomemploye"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des &Eacute;quipes avec Personnels");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    System.out.println("ID param: " + id);
    if (id != null && !id.isEmpty()) {
        pr.setAWhere(" AND idequipe = '" + id + "'");
    }
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("Enlever-id",pr.getLien() + "?but=apresTarif.jsp&acte=delete&bute=fabrication/equipe/equipe-fiche.jsp&classe="+t.getClass().getName()+"");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=fabrication/equipe/equipe-employe-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "ID employ&eacute;" ,"Nom employ&eacute;", "Nom &eacute;quipe"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>


<div class="box-body">
    <%
        out.println(pr.getTableau().getHtml());
    %>
</div>

<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
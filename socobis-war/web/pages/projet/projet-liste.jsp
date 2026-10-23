<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="fabrication.FabricationCpl" %>
<%@ page import="affichage.Liste"%>
<%@ page import="magasin.Magasin" %>

<% try{

    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Valid&eacute;e(s)", "Annul&eacute;e(s)"};

    FabricationCpl o = new FabricationCpl();
    o.setNomTable("PROJETLIB");
    String[] listeCrt = {"id","daty","lancePar","remarque","nomuser"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","daty","remarque","lanceparLib", "nomuser","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + Integer.parseInt(request.getParameter("etat")));
    }
    pr.setTitre("Liste des projets");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("projet/projet-liste.jsp");
    
    Liste[] liste = new Liste[1];
    Magasin liste0 = new Magasin();
    liste0.setNomTable("MAGASIN2");
    liste[0] = new Liste("lancePar",liste0,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute;e par");
    pr.getFormu().getChamp("remarque").setLibelle("Titre");
    pr.getFormu().getChamp("nomuser").setLibelle("Lanceur");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=projet/projet-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Date","Titre","Lanc&eacute;e par", "Lanceur", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<script>
    function changerDesignation() {
        document.projet.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="projet" id="projet">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="row">
                    <div class="col-md-4">
                        &Eacute;tat :
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                            <%
                                for( int i = 0; i < etatAff.length; i++ ){ %>
                            <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                            <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                            <% } else { %>
                            <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                            <% } %>
                            <%    }
                            %>
                        </select>
                    </div>
                </div>
                </br>
            </div>


        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>


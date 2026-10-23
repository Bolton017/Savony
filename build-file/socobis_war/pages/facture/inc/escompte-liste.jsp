<%@page import="facture.tr.Escompte"%>
<%@page import="affichage.PageRecherche"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Escompte esc = new Escompte();
    esc.setNomTable("ESCOMPTE");

    String listeCrt[] = {"idTraite"};
    String libEntete[] = {"id", "daty", "frais", "etat"};
    String listeInt[] = {};

    PageRecherche pr = new PageRecherche(esc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("facture/inc/escompte-liste.jsp");
    pr.getFormu().getChamp("idTraite").setLibelle("Traite");

    String[] colSomme = {};
    pr.creerObjetPage(libEntete, colSomme);
    if (pr.getTableau().getHtml() != null) {

%>
<section class="content-header">
    <h1>Liste Escomptes</h1>
</section>
<section class="content">
    <%        String lienTableau[] = {pr.getLien() + "?but=facture/escompte-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        String libEnteteAffiche[] = {"ID", "DATE", "FRAIS", "ETAT"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        out.println(pr.getTableau().getHtml());
    } else {
    %><center><h4>Aucun Escomptes</h4></center><%
            }
        %>
</section>

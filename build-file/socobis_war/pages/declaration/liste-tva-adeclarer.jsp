<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="mg.cnaps.compta.ComptaSousEcritureLib" %>
<%@ page import="affichage.*" %>

<% try{ 
    ComptaSousEcritureLib o = new ComptaSousEcritureLib();
    String [] val = new String[]{"COMPTASOUSECRITURETVA","COMPTASOUSECRITURETVA_D","COMPTASOUSECRITURETVA_C"};
    String [] aff = new String[]{"Tous","D&eacute;ductible","Collect&eacute;e"};
    String tvaFiltre = request.getParameter("tva");
    if (tvaFiltre == null || !java.util.Arrays.asList(val).contains(tvaFiltre)) tvaFiltre = "";
    o.setNomTable(tvaFiltre.isEmpty() ? "COMPTASOUSECRITURETVA" : tvaFiltre);
    String[] listeCrt = {"id","daty","moisdeclaration","numero","idJournal","compte","remarque","libellePiece","debit","credit"};
    String[] listeInt = {"daty","debit","credit"};
    String[] libEntete = {"id","numero","journal","compte","daty","libellePiece","remarque","debit","credit","declaration"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;critures &agrave; d&eacute;clarer");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("declaration/liste-tva-adeclarer.jsp");
    pr.setApresLienPage("&tva=" + tvaFiltre);

    affichage.Champ[] liste = new Champ[2];
    Liste mois = new Liste("moisdeclaration");
    mois.makeListeMois();
    liste[0] = mois;
    bean.TypeObjet journal = new bean.TypeObjet();
    journal.setNomTable("COMPTA_JOURNAL_VIEW");
    liste[1] = new Liste("idJournal", journal, "desce", "id");
    liste[1].ajouterVide();
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("R&eacute;f.");
    pr.getFormu().getChamp("numero").setLibelle("Intitul&eacute;");
    pr.getFormu().getChamp("moisdeclaration").setLibelle("Mois de d&eacute;claration");
    pr.getFormu().getChamp("idJournal").setLibelle("Journal");
    pr.getFormu().getChamp("compte").setLibelle("Compte");
    pr.getFormu().getChamp("libellePiece").setLibelle("Pi&egrave;ce");
    pr.getFormu().getChamp("remarque").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("debit1").setLibelle("D&eacute;bit Min");
    pr.getFormu().getChamp("debit2").setLibelle("D&eacute;bit Max");
    pr.getFormu().getChamp("credit1").setLibelle("Cr&eacute;dit Min");
    pr.getFormu().getChamp("credit2").setLibelle("Cr&eacute;dit Max");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    
    String[] colSomme = {"debit","credit"};
    pr.setNpp(100);
    pr.creerObjetPage(libEntete, colSomme);
    String[] enteteRecap = {"","Nombres","Somme des d&eacute;bits","Somme des cr&eacute;dits"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] libEnteteAffiche = {"R&eacute;f.","Intitul&eacute;","Journal","Compte","Date","Pi&egrave;ce","Libell&eacute;","D&eacute;bit","Cr&eacute;dit","Mois de d&eacute;claration"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String lienTableau[] = {pr.getLien() + "?but=compta/ecriture/sousecriture-fiche.jsp", pr.getLien() + "?but=compta/lien-fiche.jsp&type=compte"};
    String colonneLien[] = {"id", "compte"};
    String[] attributLien = {"id", "compte"};
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    pr.setApjSplitEnabled(false);
%>
<script>
    function changerDesignation() {
        document.of.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="of" id="of">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="col-md-4">
                    TVA :
                    <select name="tva" class="champ form-control" id="tva" onchange="changerDesignation()">
                        <% for (int i = 0; i < aff.length; i++) { %>
                        <option value="<%= val[i] %>" <%= val[i].equals(tvaFiltre) ? "selected" : "" %>><%= aff[i] %></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-4"></div>
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



<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="mg.cnaps.compta.ComptaSousEcritureLib" %>
<%@ page import="utilitaire.*" %>
<% try{ 
    ComptaSousEcritureLib o = new ComptaSousEcritureLib();
    o.setNomTable("COMPTASOUSECRITUREDND");
    String[] listeCrt = {"id","numero","journal","compte","libellePiece","remarque","debit","credit","daty"};
    String[] listeInt = {"daty","debit"};
    String[] libEntete = {"id","numero","journal","compte","daty","libellePiece","remarque","debit"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;critures deductibles &agrave; d&eacute;clarer");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String paramSup = "&datydebut="+request.getParameter("datydebut");
    paramSup += "&datyfin="+request.getParameter("datyfin");
    paramSup += "&designation="+request.getParameter("designation");
    pr.setApres("declaration/tva-deductible-adeclarer.jsp"+paramSup);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("numero").setLibelle("Intitul&eacute;");
    pr.getFormu().getChamp("journal").setLibelle("Journal");
    pr.getFormu().getChamp("compte").setLibelle("Compte");
    pr.getFormu().getChamp("libellePiece").setLibelle("Pi&egrave;ce");
    pr.getFormu().getChamp("remarque").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("credit").setVisible(false);
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("debit1").setLibelle("Montant min");
    pr.getFormu().getChamp("debit2").setLibelle("Montant max");

    pr.getFormu().getChamp("daty1").setDefaut(request.getParameter("datydebut"));
    pr.getFormu().getChamp("daty2").setDefaut(request.getParameter("datyfin"));

    String[] colSomme = {"debit"};
    pr.setNpp(9999);
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Intitul&eacute;","Journal","Compte","Date","Pi&egrave;ce","Libell&eacute;","Montant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String libRecap[] = {"", "Nombre", "Somme des montants"};
    pr.getTableauRecap().setLibeEntete(libRecap);

%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <input type="hidden" value="<%=request.getParameter("totalcollecter")%>" name="totalcollecter" id="totalcollecter">
            <input type="hidden" value="<%=request.getParameter("idsOrigin")%>" name="idsOrigin" id="idsOrigin">
            <input type="hidden" value="<%=request.getParameter("datydebut")%>" name="datydebut" id="datydebut">
            <input type="hidden" value="<%=request.getParameter("datyfin")%>" name="datyfin" id="datyfin">
            <input type="hidden" value="<%=request.getParameter("designation")%>" name="designation" id="designation">
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <div class="row" >
            <div class="col-md-3" style="margin-bottom: 15px;" >
                    <label for="totalCredit" class="input-label">Total Collect&eacute;es</label>
                    <input class="form-control montant" id="totalcollecter" name="totalcollecter" readonly value="<%= Utilitaire.champNull(request.getParameter("totalcollecter")) %>" type="text">
                    </div>
                <div class="col-md-3" style="margin-bottom: 15px;" >
                    <label class="input-label" for="totaldeductible" >Total Deductible</label>
                    <input class="form-control" id="totaldeductible" name="totaldeductible" type="text" readonly value="0" readonly>
                </div>
            </div>
        <br>
        <form action="<%= pr.getLien()+"?but=declaration/apresDeclarerTva.jsp"%>" method="post">
            <input type="hidden" value="declaration/fiche-declaration-tva.jsp" name="bute" id="bute">
            <input type="hidden" value="<%=request.getParameter("idsOrigin")%>" name="idsOrigin" id="idsOrigin">
            <input type="hidden" value="<%=request.getParameter("datydebut")%>" name="datydebut" id="datydebut">
            <input type="hidden" value="<%=request.getParameter("datyfin")%>" name="datyfin" id="datyfin">
            <input type="hidden" value="<%=request.getParameter("designation")%>" name="designation" id="designation">
            <%
                pr.getTableau().setNameBoutton("D&eacute;clarer");
                out.println(pr.getTableau().getHtmlWithCheckbox());
                out.println(pr.getBasPage());
            %>
        </form>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        function parseMontant(text) {
            if (!text) return 0;
            return parseFloat(
                text.replace(/\u00a0/g, '')
                    .replace(/\s/g, '')
            ) || 0;
        }

        window.recalculerTotaux = function () {
            let total = 0;

            document.querySelectorAll('input[type="checkbox"][name="ids"]:checked')
                .forEach(cb => {
                    const tr = cb.closest("tr");
                    const tds = tr.querySelectorAll("td");
                    const montantText = tds[8]?.innerText || "0";

                    total  += parseMontant(montantText);
                });

            const totaldeductible = total ;
            document.getElementById("totaldeductible").value       = totaldeductible.toLocaleString('fr-FR');
        };

        document.addEventListener("change", function (e) {
            if (e.target.matches('input[type="checkbox"][name="ids"]')) {
                recalculerTotaux();
            }
        });

        if (typeof window.CocheToutCheckbox === "function") {
            const originalCocheTout = window.CocheToutCheckbox;

            window.CocheToutCheckbox = function () {
                originalCocheTout.apply(this, arguments);
                recalculerTotaux();
            };
        }

    });
</script>

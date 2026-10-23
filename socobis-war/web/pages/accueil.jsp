<%-- 
    Document   : acceuil.jsp
    Created on : 30 mars 2023, 17:23:45
    Author     : Ny Anjara Mamisoa
--%>
<link href="${pageContext.request.contextPath}/assets/css/accueil.css" rel="stylesheet" type="text/css" />

<div class="content-wrapper">
    
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <h1 class="title-service h142pxBold m-0">Bienvenue sur votre espace de gestion</h1>
            <p class="desc-service h617pxRegular">Pilotez vos op&eacute;rations de fabrication, suivez vos stocks, transferts et inventaires en toute simplicit&eacute;.</p>
        </div>
        <div class="col-md-12 nopadding card-wrapper">

            <!-- ORDRE DE FABRICATION -->
            <a href="module.jsp?but=fabrication/ordre-fabrication-liste.jsp" class="card col-md-4 violet">
                <i class="fa-solid fa-arrow-right arrow"></i>
                <img src="${pageContext.request.contextPath}/assets/img/ordre-de-fabrication.png" class="icon"/>
                <div class="card-content">
                    <h3 class="h617pxSemibold">Ordre de fabrication</h3>
                    <p class="Body14pxRegular">
                        Cr&eacute;ez et suivez vos ordres de fabrication en toute simplicit&eacute;.
                    </p>
                </div>
            </a>

            <!-- INVENTAIRE -->
            <a href="module.jsp?but=inventaire/inventaire-categorie-saisie.jsp" class="card col-md-4 bleu">
                <i class="fa-solid fa-arrow-right arrow"></i>
                <img src="${pageContext.request.contextPath}/assets/img/inventaire.png" class="icon"/>
                <div class="card-content">
                    <h3 class="h617pxSemibold">Inventaire</h3>
                    <p class="Body14pxRegular">
                        R&eacute;alisez vos inventaires de mani&egrave;re rapide et efficace.
                    </p>
                </div>
            </a>

            <!-- ÉTAT DE STOCK -->
            <a href="module.jsp?but=stock/etatstock/etatstock-liste.jsp" class="card col-md-4 vert">
                <i class="fa-solid fa-arrow-right arrow"></i>
                <img src="${pageContext.request.contextPath}/assets/img/stock.png" class="icon"/>
                <div class="card-content">
                    <h3 class="h617pxSemibold">&Eacute;tat de Stock</h3>
                    <p class="Body14pxRegular">
                        Consultez l&rsquo;&eacute;tat r&eacute;el de votre stock en temps r&eacute;el.
                    </p>
                </div>
            </a>

            <!-- TRANSFERT DE STOCK -->
            <a href="module.jsp?but=stock/transfertstock/transfertstock-liste.jsp" class="card col-md-4 jaune">
                <i class="fa-solid fa-arrow-right arrow"></i>
                <img src="${pageContext.request.contextPath}/assets/img/transfert.png" class="icon"/>
                <div class="card-content">
                    <h3 class="h617pxSemibold">Demande de transfert de stock</h3>
                    <p class="Body14pxRegular">
                        G&eacute;rez les demandes de transfert entre vos d&eacute;p&ocirc;ts sans effort.
                    </p>
                </div>
            </a>

            <!-- MATIÈRES PREMIÈRES -->
            <a href="module.jsp?but=annexe/produit/produit-liste.jsp" class="card col-md-4 marron">
                <i class="fa-solid fa-arrow-right arrow"></i>
                <img src="${pageContext.request.contextPath}/assets/img/matieres-premieres.png" class="icon"/>
                <div class="card-content">
                    <h3 class="h617pxSemibold">Mati&egrave;res Premi&egrave;res</h3>
                    <p class="Body14pxRegular">
                        Visualisez et administrez vos mati&egrave;res premi&egrave;res efficacement.
                    </p>
                </div>
            </a>

            <a href="module.jsp?but=dashboard.jsp" class="card col-md-4">
                <i class="fa fa-solid fa-arrow-right arrow"></i>
                <img src="${pageContext.request.contextPath}/assets/img/recette.png" class="icon" />
                <div class="card-content">
                    <h3 class="h617pxSemibold">Dashboard</h3>
                    <p class="Body14pxRegular">Consultez le tableau de bord avec les analyses statistiques</p>
                </div>
            </a>
        </div>
    </div>
</div>

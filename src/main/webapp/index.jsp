<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCash | Centre de Commande</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --main-dark: #0F172A;     /* Bleu Nuit */
            --accent-mint: #2DD4BF;   /* Vert Menthe */
            --bg-page: #F8FAFC;       /* Gris Très Clair */
            --logo-bg: #1E293B;       /* Fond du Logo */
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-page);
            color: var(--main-dark);
            margin: 0; padding: 0;
            overflow-x: hidden;
        }

        /* --- SECTION HERO --- */
        .hero-section {
            background: linear-gradient(135deg, var(--main-dark) 0%, #1e293b 100%);
            padding: 60px 0 110px 0;
            color: white;
            position: relative;
            z-index: 1;
        }

        .logo-circle {
            width: 190px;
            height: 190px;
            background: var(--logo-bg);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 6px solid var(--accent-mint);
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            position: relative;
            z-index: 10;
        }

        .logo-circle img {
            width: 70%;
            height: auto;
            object-fit: contain;
        }

        /* --- VAGUE DE SÉPARATION --- */
        .wave-container {
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            line-height: 0;
            z-index: 2;
        }

        .wave-container svg {
            display: block;
            width: 100%;
            height: 70px;
        }

        .wave-container .shape-fill {
            fill: var(--bg-page);
        }

        /* --- NAVIGATION PAR CARTES --- */
        .nav-container {
            position: relative;
            z-index: 5;
            margin-top: 50px;
        }

        .menu-card {
            border: 4px solid var(--main-dark);
            border-radius: 25px;
            background: white;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            color: var(--main-dark);
            position: relative;
            overflow: hidden;
            height: 100%;
            display: block;
        }

        .menu-card::before {
            content: "";
            position: absolute;
            top: 0; left: -100%;
            width: 100%; height: 100%;
            background-color: var(--main-dark);
            transition: all 0.4s ease;
            z-index: 0;
        }

        .menu-card:hover::before {
            left: 0;
        }

        .menu-card:hover {
            color: var(--accent-mint) !important;
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }

        .card-content {
            position: relative;
            z-index: 2;
        }

        /* --- STYLE DES ICÔNES (CORRIGÉ : PAS DE CHANGEMENT DE COULEUR) --- */
        .icon-box {
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
        }

        .icon-box img {
            height: 100%;
            width: auto;
            object-fit: contain;
            transition: transform 0.3s ease; /* Uniquement l'agrandissement */
        }

        .menu-card:hover .icon-box img {
            transform: scale(1.15); /* Légère animation sans changer la couleur */
        }

        .card-title {
            font-weight: 800;
            letter-spacing: 1px;
            font-size: 0.95rem;
            margin-bottom: 5px;
        }

        footer {
            margin-top: 100px;
            color: #94a3b8;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <div class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-4 d-flex justify-content-center justify-content-lg-start mb-4 mb-lg-0">
                    <div class="logo-circle">
                        <img src="assets/img/logoNovaCash.png" alt="NovaCash Logo">
                    </div>
                </div>
                
                <div class="col-lg-8 text-center text-lg-start">
                    <h1 class="display-3 fw-extrabold mb-1">Nova<span style="color: var(--accent-mint);">Cash</span></h1>
                    <h4 class="fw-light opacity-75 mb-3">Administration de Flux</h4>
                    <p class="lead" style="max-width: 500px;">
                        Supervisez vos comptes clients et gérez vos flux financiers en temps réel.
                    </p>
                </div>
            </div>
        </div>

        <div class="wave-container">
            <svg viewBox="0 0 1200 120" preserveAspectRatio="none">
                <path d="M0,0V46.29c47.79,22.2,103.59,32.17,158,28,70.36-5.37,136.33-33.31,206.8-37.5C438.64,32.43,512.34,53.67,583,72.05c69.27,18,138.3,24.88,209.4,13.08,36.15-6,69.85-17.84,104.45-29.34C989.49,25,1113-14.29,1200,52.47V120H0Z" class="shape-fill"></path>
            </svg>
        </div>
    </div>

    <div class="container nav-container">
        <div class="row g-4 justify-content-center">
            
            <div class="col-md-5 col-lg-3">
                <a href="liste_clients.jsp" class="card menu-card p-4 text-center shadow-sm">
                    <div class="card-content">
                        <div class="icon-box">
                            <img src="assets/img/client-icon.png" alt="Clients">
                        </div>
                        <h6 class="card-title">CLIENTS</h6>
                        <p class="small opacity-75 mb-0">Gestion des comptes.</p>
                    </div>
                </a>
            </div>

            <div class="col-md-5 col-lg-3">
                <a href="transaction.jsp" class="card menu-card p-4 text-center shadow-sm">
                    <div class="card-content">
                        <div class="icon-box">
                            <img src="assets/img/flux-icon.png" alt="Flux">
                        </div>
                        <h6 class="card-title">FLUX</h6>
                        <p class="small opacity-75 mb-0">Envois & retraits.</p>
                    </div>
                </a>
            </div>

            <div class="col-md-5 col-lg-3">
                <a href="frais.jsp" class="card menu-card p-4 text-center shadow-sm">
                    <div class="card-content">
                        <div class="icon-box">
                            <img src="assets/img/tarifs-icon.png" alt="Tarifs">
                        </div>
                        <h6 class="card-title">TARIFS</h6>
                        <p class="small opacity-75 mb-0">Commissions réseau.</p>
                    </div>
                </a>
            </div>

            <div class="col-md-5 col-lg-3">
                <a href="recette.jsp" class="card menu-card p-4 text-center shadow-sm">
                    <div class="card-content">
                        <div class="icon-box">
                            <img src="assets/img/revenus-icon.png" alt="Revenus">
                        </div>
                        <h6 class="card-title">REVENUS</h6>
                        <p class="small opacity-75 mb-0">Analyse bénéfices.</p>
                    </div>
                </a>
            </div>

        </div>
    </div>

    <footer class="py-5 text-center">
        <p class="mb-0"><strong>NovaCash Digital Solutions</strong> &bull; Madagascar 2026</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
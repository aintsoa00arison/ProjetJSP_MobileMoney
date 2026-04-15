<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>M-Vola | Accueil Administration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .hero-section {
            background: linear-gradient(135deg, #ffcc00 0%, #ffb300 100%);
            padding: 80px 0;
            border-radius: 0 0 50px 50px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 50px;
        }
        .logo-v {
            background: white;
            width: 70px;
            height: 70px;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            font-weight: 800;
            color: #ffb300;
            margin: 0 auto 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .menu-card {
            border: none;
            border-radius: 25px;
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: block;
            height: 100%;
            background: white;
        }
        .menu-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1) !important;
            color: inherit;
        }
        .icon-circle {
            width: 70px;
            height: 70px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin: 0 auto 20px;
        }
        .bg-client { background: #e7f1ff; color: #0d6efd; }
        .bg-transac { background: #fff4e5; color: #fd7e14; }
        .bg-frais { background: #fdf2f2; color: #dc3545; }
        .bg-recette { background: #eafaf1; color: #198754; }
    </style>
</head>
<body>

    <div class="hero-section text-center">
        <div class="container">
            <div class="logo-v">M</div>
            <h1 class="fw-bold text-dark">M-Vola Admin</h1>
            <p class="text-dark opacity-75">Système de gestion des flux financiers</p>
        </div>
    </div>

    <div class="container">
        <div class="row g-4 justify-content-center">
            
            <div class="col-md-5 col-lg-3">
                <a href="liste_clients.jsp" class="card menu-card shadow-sm p-4 text-center">
                    <div class="icon-circle bg-client">👥</div>
                    <h5 class="fw-bold mb-2">Clients</h5>
                    <p class="text-muted small mb-0">Liste, Ajout, Modification et Suppression de clients.</p>
                </a>
            </div>

            <div class="col-md-5 col-lg-3">
                <a href="transaction.jsp" class="card menu-card shadow-sm p-4 text-center">
                    <div class="icon-circle bg-transac">💸</div>
                    <h5 class="fw-bold mb-2">Transactions</h5>
                    <p class="text-muted small mb-0">Envoi d'argent, dépôts et retraits sécurisés.</p>
                </a>
            </div>

            <div class="col-md-5 col-lg-3">
                <a href="frais.jsp" class="card menu-card shadow-sm p-4 text-center">
                    <div class="icon-circle bg-frais">📊</div>
                    <h5 class="fw-bold mb-2">Frais</h5>
                    <p class="text-muted small mb-0">Consulter la grille des tarifs des transferts.</p>
                </a>
            </div>

            <div class="col-md-5 col-lg-3">
                <a href="recette.jsp" class="card menu-card shadow-sm p-4 text-center">
                    <div class="icon-circle bg-recette">📈</div>
                    <h5 class="fw-bold mb-2">Recettes</h5>
                    <p class="text-muted small mb-0">Calcul des commissions et revenus du système.</p>
                </a>
            </div>

        </div>
    </div>

    <footer class="py-5 text-center text-muted mt-5">
        <hr class="w-25 mx-auto mb-4">
        <small>Propulsé par le système M-Vola Admin &bull; 2026</small>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
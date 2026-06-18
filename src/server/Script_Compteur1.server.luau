
local Workspace = game:GetService("Workspace")
local Elevator = Workspace:WaitForChild("Elevator") -- récupération du modèle ascenseur
local Compt = Elevator:WaitForChild("Compteur_elevator") -- récupération du modèle compteur
local Light = Compt:WaitForChild("BoardLight") -- récupération ensemble lumières model
local Demande = Compt:WaitForChild("Demande") -- le Bindable Event qui seras le signal envoyé pour utiliser notre compteur

local board ={} --tableau des ampoules réeles

local lignes=12  --variable lignes
local colonnes=8 --variable colonnes

local OrigineColor = Light:WaitForChild("1_1").Color
local OrigineMaterial = Light:WaitForChild("1_1").Material


----------------------------------------------------------------------------------
------------------- !!! TABLEAU DES SYMBOLES !!! ---------------------------------
----------------------------------------------------------------------------------


local Draw_0 =
{{0,0,0,0,0,0,0,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,0,0,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,0,0,0,0,0,0,0}}


local Draw_1 =
{{0,0,0,0,0,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,1,1,1,0,0,0},
 {0,1,1,1,1,0,0,0},
 {1,1,1,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,0,0,1,1,0,0,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,0,0,0,0,0,0,0}}

local Draw_2 =
{{0,0,0,0,0,0,0,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,0,0,0,0,1,1,0},
 {0,0,0,0,0,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,0,0,0,0,0},
 {0,1,1,0,0,0,0,0},
 {0,1,1,1,1,1,1,0},
 {0,1,1,1,1,1,1,0},
 {0,0,0,0,0,0,0,0}}




-- Dictionnaire contenant l'ensemble des draw de symbole possible
local draw = {
	["Draw_0"] = Draw_0,
	["Draw_1"] = Draw_1,
	["Draw_2"] = Draw_2
}


-- Création du tableau contenant chaque light sous la forme d'un matrice 12*8
for i=1,lignes do
	board[i]={} -- on ajoute le tableau de la ligne i
	for j=1,colonnes do
		local nom_ampoule = i.."_"..j
		board[i][j]=Light:WaitForChild(nom_ampoule)
	end
	
end

local function AllumerSymbole(symbole)
	
	-- renitialisation du tableau d'ampoules pour avoir un tableau éteint
	for i=1, lignes do
		for j=1, colonnes do
			board[i][j].Material=OrigineMaterial  -- matérieaux d'origine
			board[i][j].Color=OrigineColor  -- couleur d'origine
		end
	end 
	print("reset")
	-- application du symbole sur le board en parcourant le Draw
	
	local nom_Draw="Draw_"..tostring(symbole)
	local Table_demander = draw[nom_Draw]
	-- On va parcourir le Draw ligne par ligne pour le reproduire sur le board
	for i=1, lignes do
		for j=1, colonnes do
			if Table_demander[i][j]==1 then -- si c'est bien une case qu'on souhaite colorer car marquer d'un "1" sur le draw alors on met en rouge et néon
				board[i][j].Material=Enum.Material.Neon
				board[i][j].Color=Color3.fromRGB(255,0,0)
			end
		end
	end 
end

-- Etat initial on l'ascenseur est à l'étage 0 
AllumerSymbole(0)
Demande.Event:Connect(AllumerSymbole) -- On connecte le bindable events pour qu'il déclent la fonction de dessin de symbole lorsqu'il recoit le signal
AllumerSymbole(0) -- On allume le symbole 0 au démarrage du script
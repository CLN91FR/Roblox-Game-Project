local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animations = ReplicatedStorage:WaitForChild("Animation_go") --fichiers contenant toutes les animations
local RunService = game:GetService("RunService") --Pour l'outil HeartBeat

-- Liste d'animation qu'on initialise ----------------------------------------------

	local floss = Animations:WaitForChild("floss") --on récupère la danse du floss

------------------------------------------------------------------------------------


local model = Workspace:WaitForChild("Elevator") -- récupération du modèle ascenseur
local car = model:WaitForChild("ElevatorCar")
local compteur = model:WaitForChild("Compteur_elevator") 
local Demande_symbole_compteur = compteur:WaitForChild("Demande")
local Elevatorcar_Floor = car:WaitForChild("sol") 



-- Récupération Son ------------------------------------

	local Sound = car:WaitForChild("Sound")
	local SoundDoor = Sound:WaitForChild("ElevatorDoor")
	local SoundWaiting = Sound:WaitForChild("WaitingSound")
	local SoundDisco = Sound:WaitForChild("DiscoSon")
	
--------------------------------------------------------


-- Variable pour savoir où est l'ascenseur (on commence à l'étage 1)
local etageActuel = 0

-- Récupération des Étages
local floors = {
	[0] = model:WaitForChild("Floor1"),
	[1] = model:WaitForChild("Floor2"),
	[2] = model:WaitForChild("Floor3")
}

----- hauteur de chaque étage
local Hauteur_floors = {
	[0] = floors[0].Position.Y,
	[1] = floors[1].Position.Y,
	[2] = floors[2].Position.Y
}


-- Récupération des boutons
local ButtonsExt = model:WaitForChild("BoutonsExt")
local externalButtons = {
	[0] = ButtonsExt:WaitForChild("ExternalButton1"), -- Le bouton au RDC
	[1] = ButtonsExt:WaitForChild("ExternalButton2"), -- Le bouton au 1er
	[2] = ButtonsExt:WaitForChild("ExternalButton3"), -- Le bouton au 2ème
}

local carButtons = car:WaitForChild("Boutons")
local ButtonSound = carButtons:WaitForChild("ButtonSound") -- Son bouton click
local buttons = {
	[0] = carButtons:WaitForChild("Bouton1"),
	[1] = carButtons:WaitForChild("Bouton2"),
	[2] = carButtons:WaitForChild("Bouton3"),
	[10] = carButtons:WaitForChild("BoutonDisco");
}

-- Récupération des portes !
local Portes = model:WaitForChild("Doors")
-- Récupération portes extérieures
local PortesExt = Portes:WaitForChild("DoorsExt")
local PortesExt1 = PortesExt:WaitForChild("DoorsExt1") -- Groupe Portes RDC
local PortesExt2 = PortesExt:WaitForChild("DoorsExt2") -- Groupe Portes 1er
local PortesExt3 = PortesExt:WaitForChild("DoorsExt3") -- Groupe Portes 2ème

-- Récupération portes extérieures WAIT

local externalDoors = {
	
	[0] = {Left = PortesExt1:WaitForChild("LeftExtDoor1"), -- Portes au RDC
		   Right = PortesExt1:WaitForChild("RightExtDoor1")},
	[1] = {Left = PortesExt2:WaitForChild("LeftExtDoor2"), -- Portes au 1er
		   Right = PortesExt2:WaitForChild("RightExtDoor2")},
	[2] = {Left = PortesExt3:WaitForChild("LeftExtDoor3"), -- Portes au 2ème
		   Right = PortesExt3:WaitForChild("RightExtDoor3")}
}

-- Récupération portes internes
local PortesInt = car:WaitForChild("DoorsInt") 
-- Récupération portes internes WAIT
local PortesIntG = PortesInt:WaitForChild("LeftIntDoor") 
local PortesIntD = PortesInt:WaitForChild("RightIntDoor")


-- Récupération éléments de la cabine
local Light = car:WaitForChild("Light")
local Lumiere = Light:WaitForChild("Lumiere")


-- Récupération disco
local DiscoBall = car:WaitForChild("DiscoBall")
local Ball = DiscoBall:WaitForChild("Discoball")
local Tige = DiscoBall:WaitForChild("Bar")
local DiscoSol = car:WaitForChild("DiscoSol")
local DiscoCases = {
	
	[1] = DiscoSol:WaitForChild("DiscoCase1"),
	[2] = DiscoSol:WaitForChild("DiscoCase2"),
	[3] = DiscoSol:WaitForChild("DiscoCase3"),
	[4] = DiscoSol:WaitForChild("DiscoCase4"),
	[5] = DiscoSol:WaitForChild("DiscoCase5"),
	[6] = DiscoSol:WaitForChild("DiscoCase6"),
	[7] = DiscoSol:WaitForChild("DiscoCase7"),
	[8] = DiscoSol:WaitForChild("DiscoCase8"),
	[9] = DiscoSol:WaitForChild("DiscoCase9"),	
}


----------------------------------------------------------------------------
           -- FONCTION FONCTION FONCTION FONCTION FONCTION !!! --
----------------------------------------------------------------------------


-- FONCTION MUSIQUE

-- Fonction musique decrescendo
local function DecresendoSound(Sound, Time)
	Sound:Play()
	local info = TweenInfo.new(Time) -- "Time" est la durée en secondes
	local goal = {Volume = 0.1} --volume final
	local tweenSound = TweenService:Create(Sound, info, goal)
	tweenSound:Play()
	task.delay(Time, function() -- On lance cette mini fonction après un delai de "Time", ne stop pas le thread (signal)
		Sound:Stop()
	end)
end

-- Fonction fondue à la fin (à partir de fadetime et lenght le temps qu'on veut mettre de la musique)
local function Fade(Sound, Lenght, FadeTime)
	task.spawn(function()
		-- 1. On s'assure que le son est chargé pour connaître sa durée
		if not Sound.IsLoaded then Sound.Loaded:Wait() end

		local WaitTime = Lenght - FadeTime

		-- On lance le son à son volume normal
		Sound.Volume = 0.5 -- volume de départ
		Sound:Play()

		-- 2. On programme le fondu pour qu'il commence après l'attente
		task.delay(WaitTime, function() 
			local info = TweenInfo.new(FadeTime, Enum.EasingStyle.Linear)
			local goal = {Volume = 0} -- On descend jusqu'à 0

			local tweenSound = TweenService:Create(Sound, info, goal) 
			tweenSound:Play() -- et on lance le fade

			-- 3. On arrête le son et on nettoie une fois le fondu fini
			tweenSound.Completed:Connect(function()
				Sound:Stop()
				tweenSound:Destroy()
			end)
		end)
	end)
end


--------------- FONCTION DE DEPLACEMENT  --------------------------

-- fonction de surveillance de l'étage le plus proche de l'elevator car (utile pour le compteur)
local connexion_surveillance_compteur = nil --on initialise cette variable qui servira à stocker l'heartbeat de cette fonction (nécéssaire pour le bon fonctionnement du script)
local function Surveillance_etage(etage_cible)
	
	local hauteur_elevatorfloor = Elevatorcar_Floor.Position.Y -- position d'hauteur du sol de l'ascenseur 
	local minimum_ecart = 10000 -- valeur haute pour initialiser l'écart de l'étage le plus proche 
	local etage_leplusproche = 0 
	--- Boucle permettant de trouver l'étage le plus proche du sol de l'élevator
	-- etage : l'étage du dictionnaire étudié, hauteur : sa valeur dans le dictionnaire (valeur position Y), Hauteur_floors : nom du dictionnaire de toute les hauteur des étages
	for etage, hauteur in pairs(Hauteur_floors) do 
		local ecart = math.abs(hauteur_elevatorfloor-hauteur)
		if ecart < minimum_ecart then
			-- le nouveau ecart minimum à depasser pour être le nouveau étage le plus proche
			minimum_ecart = ecart 
			etage_leplusproche = etage
		end
	end
	
	-- Si l'étage le plus proche n'est plus celui actuelle alors on affiche le nouvel étage sur le compteur 
	if etageActuel ~= etage_leplusproche then
		etageActuel = etage_leplusproche
		Demande_symbole_compteur:Fire(etage_leplusproche) -- On active la fonction demande symbole qui est dans le script Script_Compteur 
	end
	-- Si l'étage le plus proche est l'étage ciblée pour la fin du trajet alors plus besoins de changer le compteur
	if etage_leplusproche == etage_cible then
		print("fin du compteur étage destination atteint")
		-- On arrête l'heartbeat car plus besoin de surveiller (fin de la fonction donc)
		connexion_surveillance_compteur:Disconnect()
	end
end


-- si ascenseur en mouvement rien faire
-- si bouton allumer 
local estBoutonAllumerExt = false
local estBoutonAllumerInt = false

local estEnMouvement = false
local isDiscoActive = false -- Variable globale pour savoir si le DiscoMode est actif
local DiscoAnimation = false -- Variable globale pour savoir si le disco l'animation du disco est en cours
-- info mouvement des portes

local infoPorte = TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

--fonction réunie pour fermer et ouvrir porte 
local function CloseDoors(targetFloorIndex)
	-- Fermeture des portes 
	local extDepart = externalDoors[etageActuel]

	-- Portes Extérieures
	local closeExtL = TweenService:Create(extDepart.Left, infoPorte, {CFrame = extDepart.Left.CFrame * CFrame.new(3, 0, 0)})
	local closeExtR = TweenService:Create(extDepart.Right, infoPorte, {CFrame = extDepart.Right.CFrame * CFrame.new(-3, 0, 0)})

	-- Portes Intérieures
	local closeIntL = TweenService:Create(PortesIntG, infoPorte, {CFrame = PortesIntG.CFrame * CFrame.new(3, 0, 0)})
	local closeIntR = TweenService:Create(PortesIntD, infoPorte, {CFrame = PortesIntD.CFrame * CFrame.new(-3, 0, 0)})

	-- On lance les animations
	-- On enlève les liens de WeldConstraint pour pouvoir les déplacer
	PortesIntG.Anchored = true
	PortesIntD.Anchored = true
	PortesIntG.WeldConstraint.Enabled = false
	PortesIntD.WeldConstraint.Enabled = false
	closeExtL:Play()
	closeExtR:Play()
	SoundDoor:Play() -- Son de porte
	closeIntL:Play()
	closeIntR:Play()
	closeIntR.Completed:Wait()
	-- On rétablit les liens de WeldConstraint
	PortesIntG.WeldConstraint.Enabled = true
	PortesIntD.WeldConstraint.Enabled = true
	PortesIntG.Anchored = false
	PortesIntD.Anchored = false
	-- on nettoye toutes les tween service en supprimant (gain de mémoire)
	closeExtL:Destroy()
	closeExtR:Destroy()
	closeIntL:Destroy()
	closeIntR:Destroy()
end

local function OpenDoors(targetFloorIndex)
	local extArrive = externalDoors[targetFloorIndex]

	-- Portes Extérieures
	local openExtL = TweenService:Create(extArrive.Left, infoPorte, {CFrame = extArrive.Left.CFrame * CFrame.new(-3, 0, 0)})
	local openExtR = TweenService:Create(extArrive.Right, infoPorte, {CFrame = extArrive.Right.CFrame * CFrame.new(3, 0, 0)})

	-- Portes Intérieures
	local openIntL = TweenService:Create(PortesIntG, infoPorte, {CFrame = PortesIntG.CFrame * CFrame.new(-3, 0, 0)})
	local openIntR = TweenService:Create(PortesIntD, infoPorte, {CFrame = PortesIntD.CFrame * CFrame.new(3, 0, 0)})

	-- On lance les animations
	-- On enlève les liens de WeldConstraint pour pouvoir les déplacer
	PortesIntG.Anchored = true
	PortesIntD.Anchored = true
	PortesIntG.WeldConstraint.Enabled = false
	PortesIntD.WeldConstraint.Enabled = false

	openExtL:Play()
	openExtR:Play()
	SoundDoor:Play() -- Son de porte
	openIntL:Play()
	openIntR:Play()
	openIntR.Completed:Wait()
	-- On rétablit les liens de WeldConstraint
	PortesIntG.WeldConstraint.Enabled = true
	PortesIntD.WeldConstraint.Enabled = true
	PortesIntG.Anchored = false
	PortesIntD.Anchored = false
	-- on nettoye toutes les tween service en supprimant (gain de mémoire)
	openExtL:Destroy()
	openExtR:Destroy()
	openIntL:Destroy()
	openIntR:Destroy()
end

local function moveToFloor(targetFloorIndex)
	
	-- 1. Si on est déjà à l'étage demandé ou l'ascenseur est en mouvement, on ne fait rien
	if estEnMouvement or etageActuel == targetFloorIndex then return end
	-- si le mode disco est activé
	if isDiscoActive or estBoutonAllumerExt or estBoutonAllumerInt then return end
	-- 2. On empêche de cliquer pendant le déplacement
	estEnMouvement = true
	
	
	-- Fermeture des portes 
	CloseDoors(etageActuel)
	
	-- 2. Calcul de la durée avec ta formule : 4 + 2 * (|a - b| - 1)
	local a = etageActuel+1
	local b = targetFloorIndex+1
	local dureeCalculee = 4 + 2 * (math.abs(a - b) - 1)

	--on met le son d'attente 
	Fade(SoundWaiting, dureeCalculee, 1.75)
	
	-- 3. On crée un TweenInfo spécifique pour ce trajet
	local info = TweenInfo.new(
		dureeCalculee, 
		Enum.EasingStyle.Quad, 
		Enum.EasingDirection.InOut
	)

	-- Avant de lancer l'animation de mouvement de l'ascenseur, on lance la surveillance qui actualisera l'affichage du compteur selon l'étage atteint 
connexion_surveillance_compteur = RunService.Heartbeat:Connect(function()
    Surveillance_etage(targetFloorIndex)
end)

	-- 4. Exécution du mouvement
	local targetPart = floors[targetFloorIndex]
	local goal = {CFrame = targetPart.CFrame}
	local tween = TweenService:Create(car.PrimaryPart, info, goal)

	tween:Play()

	-- C'est CETTE LIGNE qui empêche le script de continuer trop vite :
	tween.Completed:Wait()
	
	-- On envoie au compteur l'ordre d'afficher le numéro de l'étage arrivé
	-- Demande_symbole_compteur:Fire(targetFloorIndex) -- On active la fonction demande symbole qui est dans le script Script_Compteur 
	
	-- 5. On ouvre les portes quand on arrive
	OpenDoors(targetFloorIndex)
	
	-- On supprime le tween mouvement ascenseur pour gain mémoire
	tween:Destroy()
	
	-- 6. On met à jour l'étage actuel pour le prochain calcul
	etageActuel = targetFloorIndex
	
	-- 7. Quand le tween se termine, on peut cliquer à nouveau
	estEnMouvement = false
	return
end



-- FONCTION DISCO

local RetourDeLaBoule = false -- variable pour savoir si la boule est rentré dans l'ascenseur

-- Multicolore sol et lumière
local function DiscoSolAndLight()
	task.spawn(function()
		
		for i=1, 9 do --pour les 9 cases on va mettre les 9 cases plus invisible 
				DiscoCases[i].Transparency = 0
		end
		
		while DiscoAnimation do --tant qu'il y a disco
			for i=1, 9 do --pour les 9 cases on va lancer le changement aléatoire couleur toutes les 0.2s 
				DiscoCases[i].Color = Color3.fromRGB(math.random(50,255), math.random(50,255), math.random(50,255)) --limite dans le random pour éviter couleur trop sombre
			end
			Lumiere.Color = Color3.fromRGB(math.random(50,255), math.random(50,255), math.random(50,255)) -- on aplique l'effet couleur random à la lumière du plafond aussi
			task.wait(0.2) -- petite attenten entre chaque changement de couleur
		end
		--Remise à la normal
		Lumiere.Color = Color3.fromRGB(255, 253, 239) --on remet la couleur normal de la lumiere du plafond
		for i=1, 9 do --pour les 9 cases on va mettre les 9 cases en invisible 
			DiscoCases[i].Transparency = 1
		end
	end)
end



local dansesEnCours = {} -- Un dictionnaire vide : { [Joueur] = SaPisteDeDanse }  -- pour arrêter l'animation du joueur dansant précisément (pas tous à la fois)
local function DiscoDance(player)
	-- possibilité de mettre un task spawn si rallentissement du thread principal
	local body_player = player.Character --on récupère le body du joueur qui avait touché le bouton
	local humanoid = body_player:FindFirstChildOfClass("Humanoid") -- on récupère le humanoid du joueur
	local animator = humanoid:WaitForChild("Animator") -- on utilise l'outil animator du personnage pour pouvoir faire des emote
	local DanseFloss = animator:LoadAnimation(floss) -- on initialise l'animation de danse choisie
	-- Paramètres de la danse Floss --
	DanseFloss.Looped = true -- Le floss tourne en boucle
	DanseFloss:AdjustSpeed(0.90) --on peut mettre la vitesse de la danse ici
	------------------------------------------------------------------------
	DanseFloss:Play() --on lance la danse
	-- on range l'animation dans le tableau des joueurs qui dansent
	dansesEnCours[player] = DanseFloss -- on l'ajoute dans le tableau
end


-- Fonction pour son aléatoire + effet 
local function DiscoSound(time)
	local SongList= {}
	for _, son in pairs(SoundDisco:GetChildren()) do -- i le nombre de son
		table.insert(SongList, son) -- On met tout les éléments de DiscoSound dans une liste
	end
	local lenghtlist=#SongList -- on récupère la longueur de la liste avec le #
	local SonChoisi=SongList[math.random(1,lenghtlist)]
	Fade(SonChoisi, 13, 1.75)
end


-- Activation boule disco
-- Initialisation des information pour mouvement de la boule
local TrajetBouleDisco = TweenInfo.new(
	1.5, 
	Enum.EasingStyle.Quad, 
	Enum.EasingDirection.InOut
)

local infoRotation = TweenInfo.new(
	3,                           -- Temps pour faire UN tour complet (en secondes) (vitesse)
	Enum.EasingStyle.Linear,     -- Vitesse constante (indispensable pour une rotation)
	Enum.EasingDirection.InOut,  -- Direction (peu importe en Linear)                             
	-1, -- Repetion infinie   
	false -- (on ne veut pas qu'elle reparte en arrière)
)

-- Fonction pour allumer la lumière de la boule avec lumière arc en ciel
local LightWanted = false -- Variable pour savoir si on veut les lumières ou non 

local function LightBouleDisco()
	task.spawn(function()
		while LightWanted do --tant qu'on veut la lumière faire boule infini pour changer couleur
			-- On cherche tous les Attachments dans la boule
			for _, enfant in pairs(Ball:GetChildren()) do
				if enfant:IsA("Attachment") then -- Si c'est bien un attachment
					-- On cherche la SpotLight à l'intérieur de l'Attachment
					local lumiere = enfant:FindFirstChildOfClass("SpotLight")
					if lumiere then -- si on veut allumer la lumière
						lumiere.Enabled = LightWanted
						-- la lumiere change de couleur
						lumiere.Color = Color3.fromRGB(math.random(50,220), math.random(50,220), math.random(50,220))
						task.wait(0.2) -- petite attente entre chaque changement de couleur
					end
				end	
			end
		end
		-- On remet les lumières à la normal
		for _, enfant in pairs(Ball:GetChildren()) do
			if enfant:IsA("Attachment") then -- Si c'est bien un attachment
				-- On cherche la SpotLight à l'intérieur de l'Attachment
				local lumiere = enfant:FindFirstChildOfClass("SpotLight")
				if lumiere then -- si on veut allumer la lumière
					-- la lumiere va être éteinte et on va remettre sa couleur normal
					lumiere.Color = Color3.fromRGB(255, 255, 255) --on rend la couleur de la lumière blanche	
					lumiere.Enabled = LightWanted
				end
			end
		end
	end)
end


local function ActivateBouleDisco() 
	task.spawn(function()
		RetourDeLaBoule = false -- on rinitialise la variable de la boule est rentrer
		Tige.Transparency = 0 --on rend visible la tige
		Ball.Transparency = 0 --on rend visible la boule
		-- boucle pour rendre invisible les decals de la boule
		for _, enfant in pairs(Ball:GetChildren()) do
			if enfant:IsA("Decal") or enfant:IsA("Texture") then
				enfant.Transparency = 0 --on rend visible les textures de la boule
			end
		end
		Ball.Anchored = true --on ancre la boule pour qu'elle ne bouge pas
		Tige.Anchored = true --on ancre la tige pour qu'elle ne bouge pas
		Ball.WeldConstraint.Enabled = false --on désactive le weld relier à l'ascenseur pour pouvoir faire bouger la boule
		Tige.WeldConstraint.Enabled = false --on désactive le weld relier à l'ascenseur pour pouvoir faire bouger la tige
		-- définition du tween pour descendre et pour remonter après
		local allerBall = TweenService:Create(Ball, TrajetBouleDisco, {Position = Ball.Position + Vector3.new(0, -4.3 , 0)}) 
		local retourBall = TweenService:Create(Ball, TrajetBouleDisco, {Position = Ball.Position}) 
		local allerTige = TweenService:Create(Tige, TrajetBouleDisco, {Position = Tige.Position + Vector3.new(0, -4.3 , 0)}) 
		local retourTige = TweenService:Create(Tige, TrajetBouleDisco, {Position = Tige.Position}) 
		-- on lance l'aller pour descendre
		allerBall:Play() 
		allerTige:Play() 
		allerBall.Completed:Wait() -- on attend qu'il est complétement finit de descendre pour lancer les animations (tourner, lumières ?)
		Tige.CanCollide = true --on rend touchable la tige
		Ball.CanCollide = true --on rend touchable la boule
		-- maintenant que la boule est arriver en bas on allume ces lumières 
		-- tout d'abord on initialise à true la variable pour demander à la fonction la lumière
		LightWanted = true
		LightBouleDisco() -- puis on lance cette fonction
		-- Tween de la Rotation boule
		local RotationBoule = TweenService:Create(Ball, infoRotation, {Orientation = Ball.Orientation + Vector3.new(0, 360, 0)}) --on lui dit qu'on veut qu'elle tourne sur elle même
		RotationBoule:Play() --on lance la rotation
		
		repeat task.wait(0.5) until DiscoAnimation == false -- Tant que DiscoAnimation est vrai on tourne et on ne lit pas la suite du programme
		RotationBoule:Cancel() -- On stope la rotation car fin d'animation
		-- On arrête les lumières grâce à cette variable remise en false
		LightWanted = false
		-- Remise à la normal de la boule 
		Tige.CanCollide = false --on rend intouchable la tige
		Ball.CanCollide = false --on rend intouchable la boule
		--on remonte la boule
		retourBall:Play() 
		retourTige:Play() 
		retourBall.Completed:Wait() -- on valide que la boule est totallement rentré
		Ball.Transparency = 1 --on rend invisible la tige
		Tige.Transparency = 1 --on rend invisible la tige
		-- boucle pour rendre invisible les decals de la boule
		for _, enfant in pairs(Ball:GetChildren()) do
			if enfant:IsA("Decal") or enfant:IsA("Texture") then
				enfant.Transparency = 1 --on rend invisible les textures de la boule
			end
		end
		-- On supprime l'ensemble des tween utilisé (aller et retour de la boule disco) pour gain mémoire
		allerBall:Destroy()
		retourBall:Destroy()
		allerTige:Destroy()
		retourTige:Destroy()
		
		Ball.WeldConstraint.Enabled = true --on relance le weld pour que la boule revienne accroché sur l'ascenseur
		Tige.WeldConstraint.Enabled = true --on relance le weld pour que la tige revienne accroché sur l'ascenseur
		Ball.Anchored = false --on enleve l'ancrage pour qu'elle soit relié à l'ascenseur et bouge avec lui
		Tige.Anchored = false --on enleve l'ancrage pour qu'elle soit relié à l'ascenseur et bouge avec lui
		RetourDeLaBoule = true --on dit que la boule est remontée		
		print("la boule est remontée")
	end)	
end


local function ActivateDisco(player)
	if isDiscoActive or estEnMouvement or estBoutonAllumerExt or estBoutonAllumerInt  then return end --si le disco ou l'ascenseur est en mouvement est déjà actif, on ne fait rien
	--si le bouton est appuyé on lance le mode disco
	isDiscoActive = true --on active le disco
	-- fermeture des portes 
	CloseDoors(etageActuel)
	DiscoAnimation = true --on active le disco
	DiscoSound(13) --fonction musique disco
	DiscoDance(player) --fonction danse 
	DiscoSolAndLight()
	ActivateBouleDisco()
	wait(13) -- temps du mode disco
	DiscoAnimation =false --on arrete le disco
	--on arrete l'animation de danse du joueur si elle existe encore
	if dansesEnCours[player] then
		dansesEnCours[player]:Stop() -- on arrete l'animation du joueur concerné
		dansesEnCours[player]:Destroy() -- on supprime l'animation pour mémoire
		dansesEnCours[player] = nil -- on enlève l'animation du tableau
	end 
	OpenDoors(etageActuel)
	repeat task.wait(0.5) until RetourDeLaBoule == true  -- On attend que la boule est totallement rentré pour prévenir la fin du DiscoMode
	isDiscoActive=false --on arrete le disco et on previent que le DiscoMode est finit
	print("Fin du mode disco")
end
-- FONCTION MATERIEL

-- Fonction bouton lumineux
-- si bouton allumer rien faire
local estBoutonAllumerExt = false
local estBoutonAllumerInt = false

local function ButtonLightAndAction(number, location, player)
	-- number = étage demandé (10 si disco) //
	-- location = "INT" ou "EXT" pour savoir si c'est le bouton intérieur ou extérieur activé //
	-- player = joueur qui as activé le bouton (pour animation) //
	
	-- bouton exterieur
	if location == "EXT" and estBoutonAllumerExt == false then
		estBoutonAllumerExt = true
		local boutonExt=externalButtons[number]
		local couleurDeBase = boutonExt.Color
		local matiereDeBase = boutonExt.Material
		-- On prépare l'animation de retour 
		local info = TweenInfo.new(0.5) -- Durée de 0.5 secondes pour s'éteindre
		local goal = {Color = couleurDeBase}
		local tweenRetourExt = TweenService:Create(boutonExt, info, goal)
		-- On allume le bouton
		boutonExt.Material = Enum.Material.Neon -- matériaux néon
		boutonExt.Color = Color3.fromRGB(255, 255, 255) -- Un jaune brillant
		if number >= 0 and number < 4 then --si c'est un bouton qui déclenche MoveToFloor (bouton entre 1 et 3)
			moveToFloor(number) --on déclenche le déplacement de l'ascenseur
		end
		if number==10 then --si c'est un bouton qui déclenche Disco
			ActivateDisco(player) --on déclenche le mode disco en mettant le player en argument pour animation
		end
		tweenRetourExt:Play() -- retour petit à petit à la normal
		tweenRetourExt.Completed:Wait()
		boutonExt.Material = matiereDeBase
		-- on supprime la tween du bouton qui s'éteint pour gain de mémoire
		tweenRetourExt:Destroy()
		estBoutonAllumerExt = false
		print ("le bouton s'est eteint") --debug
	end

	-- bouton interieur
	if location == "INT" and estBoutonAllumerInt == false then
		task.spawn(function()
			estBoutonAllumerInt = true
			local boutonInt=buttons[number]
			local couleurDeBase = boutonInt.Color
			local matiereDeBase = boutonInt.Material
			-- On prépare l'animation de retour 
			local info = TweenInfo.new(0.5) -- Durée de 0.5 secondes pour s'éteindre
			local goal = {Color = couleurDeBase}
			local tweenRetourInt = TweenService:Create(boutonInt, info, goal)
			-- On allume le bouton
			boutonInt.Material = Enum.Material.Neon -- matériaux néon
			boutonInt.Color = Color3.fromRGB(255, 255, 255) -- Un jaune brillant
			if number >= 0 and number < 4 then --si c'est un bouton qui déclenche MoveToFloor (bouton entre 1 et 3)
				moveToFloor(number) --on déclenche le déplacement de l'ascenseur
			end
			if number==10 then --si c'est un bouton qui déclenche Disco
				ActivateDisco(player) --on déclenche le mode disco en mettant le player en argument pour animation
			end
			tweenRetourInt:Play() -- retour petit à petit à la normal
			tweenRetourInt.Completed:Wait()
			boutonInt.Material = matiereDeBase
			estBoutonAllumerInt = false
		end)
	end
end


-- CONFIGURATION DES CLICS
-- On envoie le NUMÉRO de l'étage à la fonction
-- 2. On crée une petite fonction "magique" pour gagner du temps
local function setupButtons(floorIndex)
	-- On connecte le bouton INTERNE
	buttons[floorIndex].Bouton1.MouseClick:Connect(function(player) -- "player" joueur qui as touché le bouton
		print("Le joueur " .. player.Name .. " a cliqué sur le bouton intérieur") -- debug
		ButtonSound:Play() -- Son click boutons
		ButtonLightAndAction(floorIndex, "INT", player)
	end)

	-- On connecte le bouton EXTÉRIEUR
	externalButtons[floorIndex].Bouton1.MouseClick:Connect(function(player) -- "player" joueur qui as touché le bouton 
		print("Le joueur " .. player.Name .. " a cliqué sur le bouton extérieur") -- debug
		ButtonSound:Play() -- Son click boutons
		ButtonLightAndAction(floorIndex, "EXT", player)
	end)
	
end

-- 3. On lance la configuration pour chaque étage
for i = 0, 2 do
	setupButtons(i)
end

-- configuration bouton disco

buttons[10].BoutonDisco.MouseClick:Connect(function(player) -- "player" joueur qui as touché le bouton
	print("Le joueur " .. player.Name .. " a cliqué sur le bouton disco") -- debug
	ButtonSound:Play() -- Son click boutons
	ButtonLightAndAction(10, "INT", player)
end)

class Logro{
	const juego
	
	method esImportante() = self.cantGemasOtorgadas() >=500
	
	method cantGemasOtorgadas() 
	
	method esImportanteYNoRosita() = self.esImportante() && juego.noEsRosita()
}

class Avance inherits Logro{
	var horas
	
	override method esImportante() = false
	
	override method cantGemasOtorgadas() = horas * juego.dificultad()
}

class Secreto inherits Logro{
	var cantidadGemasAOtorgar
	
	override method cantGemasOtorgadas() = cantidadGemasAOtorgar
}

class ExperinciaAlcanzada inherits Logro{
	var horas
	
	override method cantGemasOtorgadas() = horas/10 + juego.dificultad()
}

class Genio inherits ExperinciaAlcanzada{
	var jugador
	
	override method cantGemasOtorgadas() = super() * 2 + jugador.logros().size()
}


class Jugador{
	var logros = []
	var juegos = []
	var property billeteraVirtual = 0
	var cantTotalHoras
	
	method cantGemas() = logros.sum{logro=> logro.cantGemasOtorgadas()}
	
	method experienciaGamer() = cantTotalHoras * 25
	
	method comprarJuego(unJuego){
		self.validarCompra(unJuego)
		self.gastarDineroEn(unJuego)
		juegos.add(unJuego)
	}
	
	method validarCompra(unJuego){
		if(self.yaLoTieneONoLeAlcanzaPara(unJuego)){
			throw new DomainException(message = "No es posible concretar la compra")
		}
	}
	
	method yaLoTieneONoLeAlcanzaPara(unJuego) = self.yaTiene(unJuego) || self.notieneSuficientePara(unJuego)
	
	method yaTiene(unJuego) = juegos.contains(unJuego)
	
	method notieneSuficientePara(unJuego) = self.billeteraYGemas() <= unJuego.precio()
	
	method billeteraYGemas() = billeteraVirtual + self.cantGemas()
	
	//si la ejecucion no se corto es porque de alguna forma el dinero le alcanza
	method gastarDineroEn(unJuego){
		if( !(billeteraVirtual >= unJuego.precio())){
			self.convertirLogros()
		}
		billeteraVirtual -= unJuego.precio()
	}
	
	method convertirEnDinero(unLogro){
		billeteraVirtual += unLogro.cantGemasOtorgadas()
	}
	
	method convertirLogros(){
		logros.forEach{logro=>self.convertirEnDinero(logro)}
		logros.clear()
	}
	
	method juegosConLogrosImportantes()= logros.map{logro => logro.esImportanteYNoRosita()}
	
	method jugar(juego, horas) {
		cantTotalHoras += horas
		juego.estilo().otorgarLogrosA(self, horas)
	}
}



class Juego{
	var property dificultad // si descargo una expansion puede cambiar su dificultad
	const property sangrePorHora
	var property precio // inflacion xd
	var property estilo
	
	method noEsRosita() = dificultad >= 2 || sangrePorHora < 1
	
	method instalarExpansion(){
		dificultad += 1
		if(estilo == aventura){
			estilo = pelea
		}
	}
}

class generarLogros{
	
}

object aventura{
	
	method otorgarLogrosA(jugador, horas, unJuego){
		jugador.logros().add(new Secreto(cantidadGemasAOtorgar = 1/ jugador.experienciaGamer(), juego = unJuego))
	}
}

object pelea{
	
	method otorgarLogrosA(jugador, horasJugadas, unJuego){
		jugador.logros().add(new Avance(horas = horasJugadas, juego = unJuego))
		if(self.sangreTotal(horas, unJuego)>10){
			jugador.logros().add(new Secreto(cantidadGemasAOtorgar = jugador.cantTotalHoras()/10, juego = unJuego))
		}
	}
	
	method sangreTotal(horas, unJuego) = horas* unJuego.sangrePorHora()
}

object logica{
	
	method otorgarLogrosA(jugador, horas, unJuego){
		if(horas*unJuego.dificultad()>17){
			
		}
	}
}

object fps{
	
	method otorgarLogrosA(jugador, horas, unJuego){}
}

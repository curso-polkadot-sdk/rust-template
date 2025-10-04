use std::io::Write;

/// Adiciona dois numeros
const fn add(a: u32, b: u32) -> u32 {
	a + b
}

/// Apresenta uma mensagem e le um u32 do terminal
fn ler_numero(mensagem: &str) -> Option<u32> {
	let mut linha = String::new();

	// Imprime uma mensagem no terminal
	print!("{mensagem}");
	std::io::stdout().flush().ok()?;

	// Le uma linha do terminal
	std::io::stdin().read_line(&mut linha).ok()?;

	// converte a linha para u32
	linha.trim().parse::<u32>().ok()
}

#[allow(clippy::expect_used)]
fn main() {
	let a = ler_numero("digite um valor: ").expect("falha ao ler o primeiro numero");
	let b = ler_numero("digite um valor: ").expect("falha ao ler o segundo numero");
	let resultado = add(a, b);
	println!("{a} + {b} = {resultado}");
}

// Testes
#[cfg(test)]
mod tests {
	use super::add;

	#[test]
	fn testar_soma() {
		let resultado = add(2, 3);
		assert_eq!(resultado, 5);
	}
}

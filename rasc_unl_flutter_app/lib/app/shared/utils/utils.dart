

bool validarCedulaEcuatoriana(String cedula) {
  // Eliminar espacios en blanco
  cedula = cedula.trim();
  
  // Verificar que tenga exactamente 10 dígitos
  if (cedula.length != 10) {
    return false;
  }
  
  // Verificar que solo contenga números
  if (!RegExp(r'^[0-9]+$').hasMatch(cedula)) {
    return false;
  }
  
  // Verificar que los dos primeros dígitos correspondan a una provincia válida (01-24)
  int provincia = int.parse(cedula.substring(0, 2));
  if (provincia < 1 || provincia > 24) {
    return false;
  }
  
  // Verificar el tercer dígito (debe ser menor a 6 para cédulas de personas naturales)
  int tercerDigito = int.parse(cedula[2]);
  if (tercerDigito > 5) {
    return false;
  }
  
  // Algoritmo de validación del dígito verificador (módulo 10)
  List<int> coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
  int suma = 0;
  
  for (int i = 0; i < 9; i++) {
    int digito = int.parse(cedula[i]);
    int resultado = digito * coeficientes[i];
    
    // Si el resultado es mayor a 9, se suman sus dígitos
    if (resultado > 9) {
      resultado = resultado - 9;
    }
    
    suma += resultado;
  }
  
  // Calcular el dígito verificador
  int residuo = suma % 10;
  int digitoVerificador = residuo == 0 ? 0 : 10 - residuo;
  
  // Comparar con el último dígito de la cédula
  int ultimoDigito = int.parse(cedula[9]);
  
  return digitoVerificador == ultimoDigito;
}
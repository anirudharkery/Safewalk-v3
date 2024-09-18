void main() {
  List<String> ids = ["James", "Justin"];
  ids.sort();
  
  print(ids);  // Should output: [James, Justin]

  ids = ["Justin", "James"];
  ids.sort();

  print(ids);  // Should output: [James, justin] (since lowercase comes after uppercase in ASCII)
}

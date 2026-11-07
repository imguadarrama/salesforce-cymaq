public with sharing class StringListTest {
  public static List<String> generateStringList(Integer count) {
    List<String> testList = new List<String>();

    for (Integer i = 0; i < count; i++) {
      testList.add('Test ' + i);
    }

    return testList;
  }
}

package com.hobod.app;

import org.apache.hadoop.hive.ql.exec.Description;
import org.apache.hadoop.hive.ql.exec.UDF;

public class ReverseUDF extends UDF {

    public String evaluate(String str) {
        char[] array = str.toCharArray();
  	String result = "";
  	for (int i = array.length - 1; i >= 0; i--) {
  	    result = result + array[i];
  	}
  	return result;
    }
}

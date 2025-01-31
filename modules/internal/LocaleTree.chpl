/*
 * Copyright 2020-2022 Hewlett Packard Enterprise Development LP
 * Copyright 2004-2019 Cray Inc.
 * Other additional copyright holders may be indicated within.
 *
 * The entirety of this work is licensed under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 *
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// LocaleTree.chpl
//
// A tree of locales used for recursive task invocation during privatization
//

module LocaleTree {

  use ChapelLocale; // For declaration of rootLocale.

  record chpl_localeTreeRecord {
    var left, right: locale;
  }

  pragma "locale private" var chpl_localeTree: chpl_localeTreeRecord;

  proc chpl_initLocaleTree() {
    for i in LocaleSpace {
      var left: unmanaged BaseLocale? = nil;
      var right: unmanaged BaseLocale? = nil;
      var child = (i+1)*2-1;    // Assumes that indices are dense.
      if child < numLocales {
        left = rootLocale._getChild(child)._instance;
        child += 1;
        if child < numLocales then
          right = rootLocale._getChild(child)._instance;
      }
      on rootLocale._getChild(i) {
        chpl_localeTree.left._instance = left;
        chpl_localeTree.right._instance = right;
      }
    }
  }

  chpl_initLocaleTree();
}

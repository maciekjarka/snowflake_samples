CREATE OR REPLACE PROCEDURE finance_get_answer(query STRING, limit INT) COPY GRANTS
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python', 'snowflake', 'snowflake-ml-python')
HANDLER = 'finance_get_answer'
AS $$
import json
import _snowflake
import re
from snowflake.snowpark.context import get_active_session
from snowflake.core import Root 
from snowflake.cortex import Complete
def finance_get_answer(query: str, limit: int = 10):
    session = get_active_session()
    root = Root(session)
    cortex_search_service = (
        root.databases['COPILOT_DB']
        .schemas['STATS']
        .cortex_search_services['INVOICE_SEARCH_SERVICE']
    )
    context_documents = cortex_search_service.search(
        query, ['chunk'], None, limit=100
    )

    results = context_documents.results
    
    context_str = ""
    for i, r in enumerate(results):
        context_str += f"Context document {i+1}: {r['chunk']} \n" + "\n"

    context_str_out = ""
    for i, r in enumerate(results[0:10]):
        context_str_out += f"Context document {i+1}: {r['chunk'][0:100]} (...)\n" + "\n"

        
    prompt = f"""
    [INST]
            You are a helpful AI chat assistant with RAG capabilities. When a user asks you a question,
            you will also be given context provided between <context> and </context> tags. Use that context
            to provide a summary that addresses the user's question. Ensure the answer is coherent, concise,
            and directly relevant to the user's question.

            If the user asks a generic question which cannot be answered with the given context or chat_history,
            just say "I don't know the answer to that question.

            Don't saying things like "according to the provided context".
        <context>
        {context_str}
        </context>
        <question>
        {query}
        </question>
        [/INST]
        """

    response = Complete('llama3.1-70b', prompt)
    response += "\n"
    response += context_str_out

    result = response
    return result

$$;
grant all on procedure finance_get_answer(string,int) to role analyst;


call finance_get_answer('what are the products we bought from company three?',10)
grant all on procedure finance_get_answer(string,int) to role analyst

 service_metadata = st.session_state.service_metadata
    search_col = [s["search_column"] for s in service_metadata
                    if s["name"] == st.session_state.selected_cortex_search_service][0].lower()

    context_str = ""
    for i, r in enumerate(results):
        context_str += f"Context document {i+1}: {r[search_col]} \n" + "\n"

    if st.session_state.debug:
        st.sidebar.text_area("Context documents", context_str, height=500)

    return context_str, results


import streamlit as st
import os
from dotenv import load_dotenv
from langchain_community.vectorstores import FAISS
from langchain.embeddings import OpenAIEmbeddings
import openai
import streamlit.components.v1 as components


# Load environment variables
load_dotenv()

# Page configuration
st.set_page_config(
    page_title="ALY 6980 Group 2 Report Chat Bot",
    page_icon="📘",
    layout="wide"
)
# Custom CSS for better styling
st.markdown("""
    <style>
    .stApp {
        max-width: 1200px;
        margin: 0 auto;
    }
    .chat-message {
        padding: 1.5rem;
        border-radius: 0.5rem;
        margin-bottom: 1rem;
        display: flex;
        flex-direction: column;
        max-width: 800px;
        margin-left: auto;
        margin-right: auto;
    }
    .user-message {
        background-color: #f0f2f6;
        border-left: 4px solid #002D62;
    }
    .assistant-message {
        background-color: #e8f4f9;
        border-left: 4px solid #c41e3a;
    }
    .source-box {
        background-color: #f8f9fa;
        border: 1px solid #002D62;
        border-radius: 0.25rem;
        padding: 0.75rem;
        margin-top: 0.5rem;
        font-size: 0.9em;
    }
    .header-container {
        padding: 1rem;
        background-color: white;
        color: #002D62;
        margin-bottom: 2rem;
        border-bottom: 3px solid #002D62;
    }
    .logo-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem 0;
    }
    .logo-item {
        text-align: center;
        flex: 1;
    }
    .logo-item img {
        max-height: 60px;
        object-fit: contain;
    }
    .header-text {
        color: #002D62;
        margin: 0;
        text-align: center;
    }
    .source-tag {
        background-color: #002D62;
        color: white;
        padding: 0.2rem 0.5rem;
        border-radius: 0.25rem;
        font-size: 0.8em;
        margin-right: 0.5rem;
    }
    .disclaimer {
        font-size: 0.8em;
        color: #666;
        text-align: center;
        padding: 1rem;
        border-top: 1px solid #eee;
    }
    .divider {
        height: 2px;
        background-color: #002D62;
        margin: 1rem 0;
    }
    .chat-container {
        max-width: 800px;
        margin: 2rem auto;
        padding: 0 1rem;
    }
    .example-button {
        margin: 0.25rem;
    }
    .chat-input {
        max-width: 800px;
        margin: 1rem auto;
    }
    </style>
""", unsafe_allow_html=True)


# Sidebar Navigation
st.sidebar.title("Navigation")
page = st.sidebar.radio("Go to", ["Home", "Dashboards and Datasets", "Presentation"])

# Define the Home Page
if page == "Home":
    # Header Section
    st.markdown("""
        <div class="header-container">
            <div class="divider"></div>
            <h1 class="header-text">ALY 6980 Group 2 Capstone Project</h1>
            <p class="header-text" style="font-size: 1.5em; font-weight: bold; color: red;">
                Built by Syed Faizan, Team Member of Group 2, ALY 6980, Northeastern University
            </p>
        </div>
    """, unsafe_allow_html=True)

     # Display the logo using st.image
    col1, col2, col3 = st.columns([1, 2, 1])

    with col1:
        st.write("")  # Empty column for spacing

    with col2:
        st.image("images/univ.png", caption="University Logo", use_container_width=True)

    with col3:
        st.write("")  # Empty column for spacing

    # Display Team Images
    col1, col2, col3, col4, col5, col6 = st.columns(6)
    with col1:
        st.image("images/faizan.jpeg", use_container_width=True, caption="Syed Faizan")
    with col2:
        st.image("images/viquar.jpeg", use_container_width=True, caption="Viquar Ahmed")
    with col3:
        st.image("images/krutika.jpeg", use_container_width=True, caption="Krutika")
    with col4:
        st.image("images/vishnu.jpeg", use_container_width=True, caption="Vishnu")
    with col5:
        st.image("images/sanket.jpeg", use_container_width=True, caption="Sanket")
    with col6:
        st.image("images/pratham.jpeg", use_container_width=True, caption="Pratham")

    # Introduction
    st.markdown("""
This knowledge assistant is designed to answer questions related to the ALY 6980 Capstone Project analyzing Yonge Street Mission (YSM) program data, covering topics such as:

• Service Impact & Program Effectiveness (TIMES assessment analysis)

• Demographics & Socioeconomic Analysis (participant profiling, housing stability, immigration status effects)

• Predictive Modeling & Machine Learning (success prediction models, clustering analysis, disengagement forecasting)

• Resource Allocation & Strategic Planning (budget optimization, staff projections, intersectional equity analysis)

**Note:** To use the RAG-Based Report Query Assistant, the **"ASK"** button must be clicked twice:
1. Once after entering the question in the input box.
2. A second time after the **"Analyzing Sources"** message disappears.

This ensures that the query is fully processed and returns accurate results.
""")


    # Chatbot Interface
    if 'chat_history' not in st.session_state:
        st.session_state.chat_history = []
    if 'current_question' not in st.session_state:
        st.session_state.current_question = ''

    # Function to handle example question clicks
    def set_example_question(question):
        st.session_state.current_question = question
    
   

# OpenAI API key check
    openai_api_key = os.getenv("OPENAI_API_KEY")
    if not openai_api_key:
        st.error("⚠️ OpenAI API key not found! Please set the OPENAI_API_KEY environment variable.")
        st.stop()

    openai.api_key = openai_api_key

# Initialize FAISS vector store with dangerous deserialization
    try:
        embeddings = OpenAIEmbeddings()
        vector_store = FAISS.load_local("db", embeddings, allow_dangerous_deserialization=True)
    # st.success("FAISS vector store loaded successfully!")
    # Commented out the warning to suppress it
    # st.warning(
    #     "⚠️ Dangerous deserialization is enabled. Ensure the FAISS index (`db`) is from a trusted source "
    #     "to avoid potential security risks."
    # )
    except Exception as e:
        st.error(f"⚠️ Error connecting to the database: {str(e)}")
        st.stop()


    def rag(query, n_results=5):
        """RAG function with multi-source context"""
        try:
            docs = vector_store.similarity_search(query, k=n_results)
            joined_information = '; '.join([doc.page_content for doc in docs])
            messages = [
            {
                "role": "system",
                "content": (
                    "You are a knowledgeable assistant with expertise in Yonge Street Mission (YSM) program analysis, TIMES assessment frameworks, service delivery optimization, and social service predictive analytics." 
                    "Provide clear, accurate answers based on provided information and your ALY 6980 Team 2 Capstone Project context analyzing participant outcomes across 26 programs serving 4,812 unique participants."
                )
            },
            {"role": "user", "content": f"Question: {query}\nInformation: {joined_information}"}
            ]
        
            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=messages,
                temperature=0.7
            )
        
            return response.choices[0].message['content'], docs
        except Exception as e:
            raise Exception(f"Error generating response: {str(e)}")

# Chat interface in container
    chat_container = st.container()

    with chat_container:
    # Display chat history
        for message in st.session_state.chat_history:
            if message["role"] == "user":
                st.markdown(f"<div class='chat-message user-message'>💭 You: {message['content']}</div>", 
                       unsafe_allow_html=True)
            else:
                st.markdown(f"""
                <div class='chat-message assistant-message'>
                    <div style='margin-bottom: 0.5rem;'>📘 Assistant: {message['response']}</div>
                </div>
            """, unsafe_allow_html=True)

# If there's a current question in the session state, use it as the default value
    user_query = st.text_input(
        label="Ask your question about the ALY 6980 project",
        help="Type your question or click an example below",
        placeholder="Example: What are the key trends in Service Impact & Program Effectiveness ?",
        value=st.session_state.current_question,
        key="unique_user_input_key"  # Assign a unique key
    )

# Query input with examples
    st.markdown("<div class='chat-input'>", unsafe_allow_html=True)


# Example questions as buttons
    example_questions = [
    "What are the key findings about TIMES score improvements across programs?",
    "What are the service utilization trends for YSM participants?",
   "How does the participant success prediction model perform for different demographics?",
   "What are the engagement patterns observed across the 6 participant cluste"
    ]

    st.markdown("### 💡 Example Questions")
    cols = st.columns(2)
    for idx, question in enumerate(example_questions):
    # Assign a unique key for each button
        if cols[idx % 2].button(question, key=f"example_question_key_{idx}"):
            st.session_state.current_question = question  # Set the selected example question

# Single "Ask" Button Logic
    if st.button("Ask", type="primary", use_container_width=True):  # Ensure only one button
        if not user_query:
            st.warning("⚠️ Please enter a question!")
        else:
        # Append user's query to chat history
            st.session_state.chat_history.append({"role": "user", "content": user_query})
        
            with st.spinner("🔍 Analyzing sources..."):
                try:
                # Call the RAG function and get response and sources
                    response, sources = rag(user_query)
                
                # Append assistant's response to chat history
                    st.session_state.chat_history.append({
                        "role": "assistant",
                        "response": response,
                        "sources": sources
                    })
                
                # Clear the current question after processing
                    st.session_state.current_question = ''
                
                # Update app state to refresh UI
                    st.session_state['force_rerun'] = True  # Trigger UI update
                except Exception as e:
                # Log and display a detailed error message
                    st.error(f"⚠️ An error occurred while processing your query: {str(e)}")

# Close the chat input container
    st.markdown("</div>", unsafe_allow_html=True)



    # Sidebar with information
    # Sidebar with information
    with st.sidebar:
        st.image("images/ysmlogo.png", caption="Sponsor Logo", width=150)

        if st.button("Clear Chat History", key="clear_chat_sidebar"):
            st.session_state.chat_history = []
            st.rerun()
        
        st.markdown("""
        ### About This Assistant
        
       This knowledge assistant Chat Bot based on RAG is designed by Team 2 to answer questions related to the ALY 6980 Capstone Project, Northeastern University.
        Project Highlights:

        Service Impact Analysis: TIMES assessment improvements, program effectiveness across 26 programs, and optimal service sequences.
        Participant Demographics: Analysis of 4,812 participants including age, gender, immigration status, and housing stability patterns.
        Predictive Analytics: Machine learning models for success prediction (98% accuracy), disengagement forecasting, and participant clustering.
        Resource Optimization: ROI analysis, budget scenario modeling, and strategic allocation recommendations for maximum community impact.
        Equity & Outcomes: Intersectional analysis, service gap identification, and evidence-based interventions for vulnerable populations.

        #### 💡 Tips for Better Results
        - Be specific in your questions.
        - Focus on project-related topics.
        - Explore TIMES assessment improvements, and demographic analysis in detail.
        """)

    # Enhanced footer with credits
    st.markdown("---")
    st.markdown("""
    <div style="padding: 10px; font-size: 14px; color: #444;">
        <p><strong>Team Members:</strong> Syed Faizan, Viquar Ahmed, Krutika, Vishnu, Sanket, Pratham.</p>
        <p><strong>Data Sources:</strong> Provided datasets, machine learning models, and EDA outputs from the ALY 6980 Capstone Project.</p>
        <p>For additional resources or inquiries, please contact the Team Member, Syed Faizan, via the contact section.</p>
    </div>
    """, unsafe_allow_html=True)

    # Path to the project report file
    project_report_file = "ALY_6980_Experential_learning_Group_2_Mid_Term_Deliverable.pdf"

    # Section Header
    st.markdown("""
    <div class="section">
        <h3 style="color: #002D62; font-weight: bold;">About Our ALY 6980 Group 2 Final Deliverables</h3>
    </div>
    """, unsafe_allow_html=True)

    # Download Button for the Capstone Project Report
    with open(project_report_file, "rb") as file:
        st.download_button(
            label="📄 Click here to download our ALY 6980 Capstone Project Final Report",
            data=file,
            file_name="ALY_6980_Experential_learning_Group_2_Mid_Term_Deliverable.pdf",
            mime="application/pdf",
            key="download_project_report"
        )

    # Project Highlights
    st.write("""
    - **Deliverables:** Our deliverables include:
        - Power BI Dashboards
        - Power Point and Google Slides for presentation with google drive as cloud
        - Code in IPYNB files
        - GitHub Repository
        - A Detailed Report in PDF form.
        - An Interactive RAG based App that allows users to query our report
    - **Project Focus in the Final presentation:** Our project has focused on the following :
        Service Impact Assessment and Participant Demographics now included in our analysis along with Housing Stability, and Resource Allocation across YSM programs.
        The interaction between these three critical domains of social service delivery is examined and presented.
        We have updated our models and study to incorporate all the recommendations and rectifications of our Supervisor Prof. Dr. Jay Qi, PhD and YSM program stakeholders.
    - **Technologies Used:**
        - **Machine Learning Predictive Algorithms in Python**
        - **R** for Exploratory Data Analysis (EDA)
        - **LaTeX** for Report Formulation
        - **VSCode** as the website code IDE
        - **Langchain** and **FAISS** libraries to create the RAG backend
        - **GitHub** as version control and **OpenAI API** as LLM
        - **HTML**, **CSS** for front end, and **Streamlit** for App Development 
    """)


    # Contact Me section
    st.markdown('<div class="section"><h3>Contact the Team Member Syed Faizan</h3>', unsafe_allow_html=True)
    col1, col2, col3 = st.columns(3)

    with col2:
        st.markdown('<div class="button"><a href="https://www.linkedin.com/in/drsyedfaizanmd/">LinkedIn</a></div>', unsafe_allow_html=True)
    with col1:
        st.markdown('<a href="mailto:faizan.s@northeastern.edu">Email Syed Faizan</a>', unsafe_allow_html=True)
    with col2:
        st.markdown('<div class="button"><a href="https://twitter.com/faizan_data_ml">Twitter</a></div>', unsafe_allow_html=True)
    with col3:
        st.markdown('<div class="button"><a href="https://github.com/SYEDFAIZAN1987">GitHub</a></div>', unsafe_allow_html=True)
        st.markdown('</div>', unsafe_allow_html=True)

    

# Dashboards and Datasets Page
elif page == "Dashboards and Datasets":
    st.markdown("## Dashboards and Datasets")

    # Dashboards Section
    st.markdown("### Dashboards")
    dashboards = {
        "Dashboard": "Dashboards/YSM_GroupProject.pbix"
      
    }

    for idx, (name, path) in enumerate(dashboards.items()):  # idx is defined here
        if os.path.exists(path):  # Check if the file exists
            with open(path, "rb") as file:  # Open the file in binary mode
                st.download_button(
                    label=f"📊 Download {name}",  # Dynamic label
                    data=file,  # File data
                    file_name=os.path.basename(path),  # File name for download
                    mime="application/octet-stream",  # MIME type
                    key=f"download_button_{idx}"  # Unique key using idx
                )


    # Datasets Section
    st.markdown("### Datasets")
    datasets = {
        "Consolidated Data": "Consolidated_Datasets/YSM_Merged_Data.xlsx"
        
    }

    for idx, (name, path) in enumerate(datasets.items()):
        if os.path.exists(path):
            with open(path, "rb") as file:
                st.download_button(
                    label=f"📂 Download {name}",
                    data=file,
                    file_name=os.path.basename(path),
                    mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    key=f"dataset_button_{idx}"
                )

# Presentation Page
elif page == "Presentation":
    st.markdown("## Presentation")

    presentation_file = "Presentation/ALY6980_Group2_PPT.pptx"
    if os.path.exists(presentation_file):
        with open(presentation_file, "rb") as file:
            st.download_button(
                label="📂 Download the Final Presentation",
                data=file,
                file_name=os.path.basename(presentation_file),
                mime="application/vnd.openxmlformats-officedocument.presentationml.presentation",
                key="download_demographic"
            )

    # Embed Google Slides Presentation
    google_slides_embed_url = "https://docs.google.com/presentation/d/e/2PACX-1vRKzr6rVKfypYbU0VfAjw8bKFj5IpyPefTZldsj_aimryr_dqHBv0IQ8vy6o410nQ/pubembed?start=false&loop=false&delayms=15000"

    st.markdown(
        f"""
        <iframe src="{google_slides_embed_url}" frameborder="0" width="100%" height="600px" 
        allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>
        """,
        unsafe_allow_html=True,
    )

     # Embed Google Slides Presentation
    google_slides_embed_url2 = "https://docs.google.com/presentation/d/e/2PACX-1vRKzr6rVKfypYbU0VfAjw8bKFj5IpyPefTZldsj_aimryr_dqHBv0IQ8vy6o410nQ/pubembed?start=false&loop=false&delayms=15000"

    st.markdown(
        f"""
        <iframe src="{google_slides_embed_url2}" frameborder="0" width="640" height="389" 
        allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>
        """,
        unsafe_allow_html=True,
    )



# Sidebar Details
with st.sidebar:
    st.image("images/ysmlogo.png", caption="Sponsor Logo", width=150)
    st.markdown("""
    ### About the Project
    **Project Highlights:**
    - Times Score Analysis
    - Housing Trends
    - Demographics Analysis
    - Predictive Analytics
    """)
    if st.button("Clear Chat History",key="example_sidebar"):
        st.session_state.chat_history = []

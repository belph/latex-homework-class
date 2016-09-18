% LaTeX Homework Style Class
% Based on github's jdavis/latex-homework-template
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{homework}[2016/01/18 Homework Style Class]

\LoadClass{article}

% Base Packages
\RequirePackage{fancyhdr}
\RequirePackage{extramarks}
\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}
\RequirePackage{mathtools}
\RequirePackage{csquotes}
\RequirePackage{enumerate}
\RequirePackage{listings}
\RequirePackage{subcaption}
\RequirePackage{xkeyval}
\RequirePackage{expl3}
\RequirePackage{xparse}
\RequirePackage{datenumber}
\RequirePackage{enumitem}
\RequirePackage{mathpartir}
%\RequirePackage{calc}

\newif\if@loadalg\@loadalgfalse
\newif\if@loadtikz\@loadtikzfalse
\DeclareOption{alg}{\@loadalgtrue}
\DeclareOption{tikz}{\@loadtikztrue}
\ProcessOptions\relax

% Optional Inclusions
\if@loadalg
  \RequirePackage{algorithm}
  \RequirePackage{algpseudocode}
  \algnewcommand{\algorithmicgoto}{\textbf{go to}}%
  \algnewcommand{\Goto}[1]{\algorithmicgoto~\ref{#1}}
  \algnewcommand\algorithmicinput{\textbf{Input:}}
  \algnewcommand\Input{\item[\algorithmicinput]}
  \algnewcommand\algorithmicoutput{\textbf{Output:}}
  \algnewcommand\Output{\item[\algorithmicoutput]}
  \algdef{SE}[DOWHILE]{Do}{doWhile}{\algorithmicdo}[1]{\algorithmicwhile\ #1}%
  \newcommand{\alg}[1]{\textsc{\bfseries \footnotesize #1}}
\fi
  
\if@loadtikz
  \RequirePackage{tikz}
  \RequirePackage{tikz-qtree}
  \usetikzlibrary{matrix,fit,automata,positioning}
\fi

% Configurable Parameters

% Set the start year (sanity)
%\setstartyear{1800}
% Set the date to today
\setdatetoday

% Check for default semester
\ExplSyntaxOn

% Returns the current semester (e.g. ``Spring 2016''')
\DeclareExpandableDocumentCommand\CurrentSemester{}
{
  \GetSemester{\thedateyear}{\thedatemonth}{\thedateday}
}

% Returns the semester of the given year/month/day
\DeclareExpandableDocumentCommand\GetSemester{m m m}
{
  \grill_day_month_season:nn{#2}{#3}\  #1
}


% \grill_tie_break <num> <lim> <if_lt :: T> <if_geq :: T> => T
% Returns <if_lt> if <num> < <lim>; otherwise returns <if_geq>
\cs_new:Npn \grill_tie_break:nnnn #1 #2 #3 #4
{
  \if_int_compare:w {#1} {<} {#2}
  #3
  \else
  #4
  \fi:
}

% \grill_month_day_season <month> <day> => String
% Returns the season for the given date
\cs_new:Npn \grill_day_month_season:nn #1 #2
{
  \int_case:nn{#1}
  {
    {1}{Spring}
    {2}{Spring}
    {3}{Spring}
    {4}{Spring}
    {5}{\grill_tie_break {#2} {10} {Spring} {Summer\  1}}
    {6}{Summer\  1}
    {7}{Summer\  2}
    {8}{\grill_tie_break {#2} {25} {Summer\  2} {Fall}}
    {9}{Fall}
    {10}{Fall}
    {11}{Fall}
    {12}{Fall}
  }
}
\ExplSyntaxOff

%
% Homework Details
%   - Title
%   - Due date
%   - Class
%   - Section/Time
%   - Instructor
%   - Author
%

\newcommand{\hmwkTitle}{Homework\ Title}
\newcommand{\hmwkDueTime}{Some Time}
\newcommand{\hmwkDueDateMonth}{\thedatemonth}
\newcommand{\hmwkDueDateDay}{\thedateday}
\newcommand{\hmwkDueDateYear}{\thedateyear}
\newcommand{\hmwkClassTime}{Class Semester}
\def\hmwkDueDate{\datedate}
\def\updateDueDate{
  \setdate{\hmwkDueDateYear}{\hmwkDueDateMonth}{\hmwkDueDateDay}
  \updateClassTime
}
\def\updateClassTime{\ifdefined\my@hwduetime \relax \else
  \renewcommand{\hmwkClassTime}{\CurrentSemester} \fi}
\newcommand{\hmwkMaybeDueTime}{\ifdefined\my@hwduetime {\ at \hmwkDueTime} \else {}\fi}
\newcommand{\hmwkClass}{Class Name}

\newcommand{\hmwkClassInstructor}{Professor}
\newcommand{\hmwkAuthorName}{My Name}
\newcommand{\hmwkAuthorHeaderName}{My Name}

\makeatletter

\define@key{hwparams}{title}{
  \renewcommand{\hmwkTitle}{#1}
  \def\my@hwname{#1}
}
\define@key{hwparams}{time}{
  \renewcommand{\hmwkDueTime}{#1}
  \def\my@hwduetime{#1}
}
\define@key{hwparams}{month}{
  \renewcommand{\hmwkDueDateMonth}{#1}
  \updateDueDate
  \def\my@hwdatemonth{#1}
}
\define@key{hwparams}{day}{
  \renewcommand{\hmwkDueDateDay}{#1}
  \updateDueDate
  \def\my@hwdateday{#1}
}
\define@key{hwparams}{year}{
  \renewcommand{\hmwkDueDateYear}{#1}
  \updateDueDate
  \def\my@hwdateyear{#1}
}
\define@key{hwparams}{class}{
  \renewcommand{\hmwkClass}{#1}
  \def\my@hwclass{#1}
}
\define@key{hwparams}{classtime}{
  \renewcommand{\hmwkClassTime}{#1}
  \def\my@hwclasstime{#1}
}
\define@key{hwparams}{instructor}{
  \renewcommand{\hmwkClassInstructor}{#1}
  \def\my@hwinstructor{#1}
}
\define@key{hwparams}{author}[\hmwkAuthorName]{
  \renewcommand{\hmwkAuthorName}{#1}
  \def\my@hwauthor{#1}
}
\define@key{hwparams}{authorHeader}[\hmwkAuthorHeaderName]{
  \renewcommand{\hmwkAuthorHeaderName}{#1}
  \def\my@hwauthorhdr{#1}
}

\makeatother

\newcommand{\sethwparams}[1]{\setkeys{hwparams}{#1}}
\IfFileExists{config.tex}{\include{config}}

% Definitions and setup
\topmargin=-0.45in
\evensidemargin=0in
\oddsidemargin=0in
\textwidth=6.5in
\textheight=9.0in
\headsep=0.25in

\linespread{1.1}

\pagestyle{fancy}
\lhead{\hmwkAuthorHeaderName}
\chead{\hmwkClass\ (\hmwkClassInstructor): \hmwkTitle}
\rhead{\firstxmark}
\lfoot{\lastxmark}
\cfoot{\thepage}

\renewcommand\headrulewidth{0.4pt}
\renewcommand\footrulewidth{0.4pt}
\newcommand{\defeq}{\vcentcolon=}
\newcommand{\st}{\text{ s.t. }}
\newcommand{\viz}{\textit{viz.\ }}

\renewcommand{\thefootnote}{\fnsymbol{footnote}}

\setlength\parindent{0pt}

%
% Create Problem Sections
%

\newcommand{\enterProblemHeader}[1]{
    \nobreak\extramarks{}{Problem \arabic{#1} continued on next page\ldots}\nobreak{}
    \nobreak\extramarks{Problem \arabic{#1} (continued)}{Problem \arabic{#1} continued on next page\ldots}\nobreak{}
}

\newcommand{\exitProblemHeader}[1]{
    \nobreak\extramarks{Problem \arabic{#1} (continued)}{Problem \arabic{#1} continued on next page\ldots}\nobreak{}
    \stepcounter{#1}
    \nobreak\extramarks{Problem \arabic{#1}}{}\nobreak{}
}

\setcounter{secnumdepth}{0}
\newcounter{partCounter}
\newcounter{homeworkProblemCounter}
\setcounter{homeworkProblemCounter}{1}
\nobreak\extramarks{Problem \arabic{homeworkProblemCounter}}{}\nobreak{}

% Fix latex
\def\smallskip{\vskip\smallskipamount}
\def\medskip{\vskip\medskipamount}
\def\bigskip{\vskip\bigskipamount}

%\newcounter{hwthm}[section]

% Hand made theorem
\newcounter{thm}[section]
\renewcommand{\thethm}{\thesection.\arabic{thm}}
\def\claim#1{\par\medskip\noindent\refstepcounter{thm}\hbox{\bf Theorem. #1.}
\it\ %\ignorespaces
}
\def\endclaim{
\par\medskip}
\newenvironment{thm}{\claim}{\endclaim}

%
% Homework Problem Environment
%
% This environment takes an optional argument. When given, it will adjust the
% problem counter. This is useful for when the problems given for your
% assignment aren't sequential. See the last 3 problems of this template for an
% example.
%
\newenvironment{homeworkProblem}[1][-1]{
    \ifnum#1>0
        \setcounter{homeworkProblemCounter}{#1}
    \fi
    \section{Problem \arabic{homeworkProblemCounter}}
    \setcounter{partCounter}{1}
    %\setcounter{hwthm}{0}
    \enterProblemHeader{homeworkProblemCounter}
}{
    \exitProblemHeader{homeworkProblemCounter}
}

%
% Title Page
%

\title{
    \vspace{2in}
    \textmd{\textbf{\hmwkClass:\ \hmwkTitle}}\\
    \normalsize\vspace{0.1in}\small{Due\ on\ \hmwkDueDate\hmwkMaybeDueTime}\\
    \vspace{0.1in}\large{\textit{\hmwkClassInstructor,\ \hmwkClassTime}}
    \vspace{3in}
}

\author{\textbf{\hmwkAuthorName}}
\date{}

\renewcommand{\part}[1]{\textbf{\large Part \Alph{partCounter}}\stepcounter{partCounter}\\}

%
% Various Helper Commands
%

% Useful for algorithms
%\newcommand{\alg}[1]{\textsc{\bfseries \footnotesize #1}}

% For derivatives
\newcommand{\deriv}[1]{\frac{\mathrm{d}}{\mathrm{d}x} (#1)}

% For partial derivatives
\newcommand{\pderiv}[2]{\frac{\partial}{\partial #1} (#2)}
\newcommand{\Mod}[1]{\ (\text{mod}\ #1)}

% Integral dx
\newcommand{\dx}{\mathrm{d}x}

% Alias for the Solution section header
\newcommand{\solution}{\textbf{\large Solution}}

% Probability commands: Expectation, Variance, Covariance, Bias
\newcommand{\E}{\mathrm{E}}
\newcommand{\Var}{\mathrm{Var}}
\newcommand{\Cov}{\mathrm{Cov}}
\newcommand{\Bias}{\mathrm{Bias}}

\newtheorem{definition}{Definition}
\newtheorem{lemma}{Lemma}
\newtheorem{corollary}{Corollary}
\newtheorem{prop}{Proposition}
\newtheorem{remark}{Remark}
\newtheorem{tclaim}{Claim}

\providecommand\phantomsection{}
\newcommand{\pitem}[2]{\item \textbf{\upshape #1} #2}
\newcommand{\since}[1]{\tag*{$\because$\ #1}}
\newcommand{\subtoc}[1]{
  \phantomsection
  \addtocounter{subsection}{1}
  \addcontentsline{toc}{subsection}{#1}
}
\newcommand{\ptoc}[1]{\subtoc{Proof of~\ref{#1}}}
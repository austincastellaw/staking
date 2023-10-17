import styles from "../styles/Home.module.css";

export default function StakingData() {
    return (
        <section className={styles.stakingDataContainer}>
            <section className={styles.StakingData}>
                <span>Total Staked Tokens:</span>
                <span classname={styles.stakingData_value}> 120,908,000</span>
            </section>
            <section className={styles.StakingData}>
                <span>Total Renewal Paid:</span>
                <span classname={styles.stakingData_value}> 20,000</span>
            </section>
            <section className={styles.StakingData}>
                <span>Stakers:</span>
                <span classname={styles.stakingData_value}> 8,120</span>
            </section>
        </section>
    )
}
